defmodule Levenshtein do
  @moduledoc """
  Implementation of the Levenshtein edit distance algorithm
  patterned off of the "Iterative with two matrix rows" pseudocode
  example found at https://en.wikipedia.org/wiki/Levenshtein_distance.
  """

  def distance(a, b) when a==b, do: 0

  def distance(a, b) when is_bitstring(a) do
    distance(String.to_charlist(a), String.to_charlist(b))
  end

  def distance(a_chars, b_chars) do
    a_len = Enum.count(a_chars)
    b_len = Enum.count(b_chars)

    # Order so that s represents the shorter string
    {s_chars, t_chars} = cond do
      b_len < a_len ->
        { b_chars, a_chars }
      true ->
        { a_chars, b_chars }
    end

    v0 = Enum.map((0..length(t_chars)), fn(x) -> x end)

    distance(s_chars, t_chars, v0, 0)
  end

  def distance(s_chars, _t_chars, v0, i) when i==length(s_chars) do
    Enum.reverse(v0)
    |> Enum.take(1)
    |> hd
  end

  def distance(s_chars, t_chars, v0, i) do
    v1 = Enum.map((0..length(t_chars)), fn(x) ->
      case x==0 do
        true  -> i+1
        false -> 0
      end
    end)

    compare(v0, v1, s_chars, t_chars, i, 0)
  end

  def compare(_v0, v1, s_chars, t_chars, i, j) when j==length(t_chars) do
    distance(s_chars, t_chars, v1, i+1)
  end

  def compare(v0, v1, s_chars, t_chars, i, j) do
    cost = case Enum.at(s_chars, i) == Enum.at(t_chars, j) do
      true  -> 0
      false -> 1
    end

    new_val = Enum.min(
                      [Enum.at(v1, j)+1,
                       Enum.at(v0, j+1)+1,
                       Enum.at(v0, j)+cost]
    )

    v1_new = List.replace_at(v1, j+1, new_val)

    compare(v0, v1_new, s_chars, t_chars, i, j+1)
  end
end

