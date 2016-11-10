defmodule ChallengeTest do
  use ExUnit.Case
  doctest Challenge

  test "splits input into a list of test cases and a word list (dictionary)" do
    { tc, wl } = Challenge.read("example-tests/input1")
    assert tc == ["recursiveness", "elastic", "macrographies"]
    assert Enum.at(wl, 0) == 'aa' # charlist, not string
  end

  test "determines if the first 2 chars of 2 string contain a common char" do
    a = String.to_charlist("autonomy")
    b = String.to_charlist("beetle")
    c = String.to_charlist("auto")

    assert Challenge.close?(a, b) == false
    assert Challenge.close?(a, c) == true
  end

  test "finds all of the friends of a given word" do
    { _tc, wl } = Challenge.read("example-tests/input1")
    friends = Challenge.search("elastic", wl)
    assert Enum.count(friends) == 3

    friends2 = Challenge.search("recursiveness", wl)
    assert Enum.count(friends2) == 1
  end
end

