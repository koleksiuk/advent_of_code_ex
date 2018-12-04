defmodule Day01.Device do
  def parse_frequency(line) when is_binary(line) do
    { sign, value } = String.split_at(line, 1)

    create_number(sign, String.to_integer(value))
  end

  defp create_number("-", value) do
    -value
  end

  defp create_number("+", value) do
    value
  end
end
