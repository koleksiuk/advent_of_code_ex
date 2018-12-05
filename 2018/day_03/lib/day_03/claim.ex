defmodule Day03.Claim do
  defstruct [:id, :height, :width, :x, :y]

  def build(%{ "id" => id, "height" => height, "width" => width, "x" => x,
               "y" => y}) do
    %__MODULE__{
      id: String.to_integer(id),
      height: String.to_integer(height),
      width: String.to_integer(width),
      x: String.to_integer(x),
      y: String.to_integer(y)}
  end

  def range_x(claim) do
    claim.x..claim.x+claim.width-1
  end

  def range_y(claim) do
    claim.y..claim.y+claim.height-1
  end
end
