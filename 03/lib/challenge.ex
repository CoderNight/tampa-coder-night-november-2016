defmodule Challenge do

  @doc """
  Read input file and split into a list of words to process
  and a ~ 10K word dictionary.
  """
  def read(path) do
		Stream.resource(fn -> File.open!(path) end,
		fn file ->
			case IO.read(file, :line) do
				:eof -> {:halt, file}
				line -> {[line], file}
			end
		end,
		fn file -> File.close(file) end)
    |> Enum.map(&String.strip/1)
    |> split_input
  end

  @doc """
  Split list of strings into those before and after END OF INPUT.
  Converts the word list into a list of charlists, not strings, because
  later processing will be done on a character-by-character basis.
  Erlang and Elixir are "fun" that way.
  """
  def split_input(list) do
    end_idx       = Enum.find_index(list, fn(s) -> s == "END OF INPUT" end)
    { tc, wl }    = Enum.split(list, end_idx)

    [_hwl|twl]    = wl # remove END OF INPUT
    word_charlist = Enum.map(twl, fn(s) -> String.to_charlist(s) end)

    { tc, word_charlist }
  end

  @doc """
  For each word in words, process against the dictionary list
  in parallel using basic processes, without OTP.
  Note, it's critical to use ^pid in the receive block
  instead of just pid, otherwise results
  might not be returned in order.
  """
  def search_all(words, list) do
    words
    |> Enum.map(fn(word) ->
      pid = spawn(Challenge, :search_async, []);
      { pid, send(pid, { self, word, list }) }
    end)
    |> Enum.map(fn({pid, _}) ->
      receive do { ^pid, result } -> result end
    end)
  end

  @doc """
  Performs search asynchronously. Sends results
  to "sender" pid (the pid that spawned this process).
  """
  def search_async do
    receive do
      { sender, word, list } -> send sender, { self, search(word, list) }
    end
  end

  @doc """
  Search word_list for friends of word.
  """
  def search(word, word_list) do
    word_chars = String.to_charlist(word)
    word_list2 = word_list -- [word_chars]
    cur_list   = prune(word_list2, word_chars)
    search(word_chars, word_list2, cur_list, [word_chars], [])
  end

  @doc """
  Matches end state where there are no more friends to search
  and dictionary has been entirely searched.
  """
  def search(_word, _word_list, [], friends, []) do
    friends
  end

  @doc """
  Matches state where dictionary has been entirely searched
  for _word but there are more friends to search against.
  """
  def search(_word, word_list, [], friends, _to_search=[h|t]) do
    cur_list = prune(word_list, h)
    search(h, word_list, cur_list, friends, t)
  end

  @doc """
  Matches state where word is to be compared to the head of the word_list.
  """
  def search(word, word_list, _cur_list=[h|t], friends, to_search) do
    case Levenshtein.distance(word, h) <= 1 do
      true ->
        # Add the head word to the list of friends and
        # list of words to search. Remove it from the dictionaries.
        search(word, word_list -- [h], t -- [h], [h|friends], [h|to_search])
      false ->
        search(word, word_list, t, friends, to_search)
    end
  end

  @doc """
  To reduce the search space, remove items from the list by these criteria:
  1.  Words whose length is > 1 char different than the search word.
  2.  Words that do not share at least 1 common char between the first 2 chars
      of both words being compared. This is also performed for the last 2 chars.
  """
  def prune(list, word) do
    reverse_word = Enum.reverse(word)

    list
    |> Enum.filter(fn(list_word) -> abs(Enum.count(word) - Enum.count(list_word)) <= 1 end) # 1
    |> Enum.filter(fn(list_word) -> close?(word, list_word) && close?(reverse_word, Enum.reverse(list_word)) end) # 2
  end

  @doc """
  Given two words as charlists, do the first two chars
  of each have at least one char in common? This helps
  to shortcut comparisons.
  """
  def close?(a_chars, b_chars) do
    Enum.take(a_chars, 2) ++ Enum.take(b_chars, 2)
    |> Enum.uniq
    |> Enum.count < 4
  end
end

