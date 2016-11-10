defmodule LevenshteinTest do
  use ExUnit.Case
  import Levenshtein
  doctest Levenshtein

  test "calculates distance when string are equal" do
    assert distance("cat", "cat") == 0
  end

  test "calculates distance with only substitution" do
    assert distance("cat", "hat") == 1
    assert distance("cat", "lot") == 2
  end

  test "calculates distance with deletions" do
    assert distance("cat", "dogcat") == 3
    assert distance("cat", "catdog") == 3
    assert distance("cat", "dcatog") == 3
  end

  test "calculates distance with insertions" do
    assert distance("dog", "doog") == 1
  end

  test "calculates other examples" do
    assert distance("kitten", "sitting")    == 3
    assert distance("Saturday", "Sunday")   == 3
    assert distance("elastic", "lactic")    == 2
    assert distance("lastins", "lastings")  == 1
    assert distance("elastins", "lastings") == 2
  end
end

