defmodule Day05 do
  require IEx
  @default_path "./priv/input.txt"
  def run(path \\ @default_path) do
    {:ok, str} = File.read(path)

    react(String.codepoints(str)) |> String.length
  end

  @doc ~S"""

  iex> Day05.react("dabAcCaCBAcCcaDA")
  "dabCBAcaDA"
  """
  def react(str) when is_binary(str) do
    react(String.codepoints(str))
  end

  def react(codepoints) when is_list(codepoints) do
    react(codepoints, [])
  end

  def react([], acc) do
    Enum.join(acc)
  end

  def react([letter|codepoints], acc) do
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

    react(codepoints, new_acc)
  end

  def remove(codepoints, letter) do
    Enum.reject(codepoints, fn (x) -> letter == String.downcase(x) end)
  end
end
