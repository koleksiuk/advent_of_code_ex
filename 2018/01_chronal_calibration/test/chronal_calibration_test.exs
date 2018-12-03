defmodule ChronalCalibrationTest do
  use ExUnit.Case

  setup do
    stream = File.stream!("./var/input2.txt")
    {:ok, %{stream: stream}}
  end

  test "sum sums the stream", context do
    assert ChronalCalibration.sum(context[:stream]) == 1
  end

  test "find_repeated_frequency finds first repated frequency", context do
    assert ChronalCalibration.find_repeated_frequencies(context[:stream]) == 14
  end
end
