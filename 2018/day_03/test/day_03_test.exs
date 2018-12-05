defmodule Day03Test do
  use ExUnit.Case
  doctest Day03

  test "run returns correct result" do
    assert Day03.run("./var/input_test.txt") == 4
  end

  test "find_not_overlapped returns id that does not overlapp with others" do
    assert Day03.find_not_overlapped("./var/input_test.txt") == 3
  end
end
