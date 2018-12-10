defmodule Day05 do
  require IEx
  @default_path "./priv/input.txt"
  def run(path \\ @default_path) do
    {:ok, str} = File.read(path)

    reduce(String.codepoints(str))
  end

  @doc ~S"""

  iex> Day05.reduce("dabAcCaCBAcCcaDA")
  "dabCBAcaDA"
  """
  def reduce(str) when is_binary(str) do
    reduce(String.codepoints(str))
  end

  def reduce(codepoints) when is_list(codepoints) do
    reduce(codepoints, [])
  end

  def reduce([], acc) do
    Enum.join(acc)
  end

  def reduce([letter|codepoints], acc) do
    new_acc = case Enum.at(acc, -1) do
                nil -> [letter]
                prev_letter ->
                  case String.upcase(prev_letter) == String.upcase(letter) do
                    false -> acc ++ [letter]
                    true ->
                      case prev_letter == letter do
                        true -> acc ++ [letter]
                        false -> Enum.slice(acc, 0..-2)
                      end
                  end
              end

    reduce(codepoints, new_acc)
  end
end
