defmodule Day03.LineParser do
  @line_regex ~r/\#(?<id>\d+) @ (?<x>\d+),(?<y>\d+): (?<width>\d+)x(?<height>\d+)/

  @doc ~S"""

  iex> Day03.LineParser.parse("#2 @ 3,1: 4x4")
  %{"height" => "4", "id" => "2", "width" => "4", "x" => "3", "y" => "1"}

  iex> Day03.LineParser.parse("#20 @ 30,10: 40x40")
  %{"height" => "40", "id" => "20", "width" => "40", "x" => "30", "y" => "10"}
  """
  def parse(line) do
    Regex.named_captures(@line_regex, line)
  end
end
