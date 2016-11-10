defmodule TestInputs do

  def run do
    (1..4)
    |> Stream.map(fn(n) -> run_input(n) end)
    |> Enum.map(fn(result) -> IO.inspect(result) end)

    nil
  end

  def run_input(n) do
    in_path  = "example-tests/input#{n}"
    out_path = "example-tests/output#{n}"

    {tc, wl} = Challenge.read(in_path)

    {msec, results} = :timer.tc(fn -> Challenge.search_all(tc, wl) end, [])
    counts = results |> Enum.map(fn(list) -> Enum.count(list) end)

    output_counts = Stream.resource(fn -> File.open!(out_path) end,
		fn file ->
			case IO.read(file, :line) do
				:eof -> {:halt, file}
				line -> {[line], file}
			end
		end,
		fn file -> File.close(file) end)
    |> Enum.map(&String.strip/1)
    |> Enum.map(&String.to_integer/1)

    sec = msec / 1_000_000
    {counts==output_counts, sec, counts, output_counts}
  end
end

