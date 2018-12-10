defmodule Day05 do
  require IEx
  @default_path "./priv/input.txt"
  def run(path \\ @default_path) do
    {:ok, str} = File.read(path)

    react(String.codepoints(str)) |> String.length
  end

  def test_strings(path \\ @default_path) do
    {:ok, str} = File.read(path)

    codepoints = String.codepoints(str)

    letters = Enum.map(?a..?z, fn x -> <<x ::utf8>> end)

    stream = Task.async_stream(letters, fn letter ->
      polymer = remove(codepoints, letter)

      new_polymer = react(polymer)

      {letter, String.length(new_polymer)}
    end, timeout: 20_000)

    Enum.reduce(stream, Map.new, fn {:ok, {letter, length}}, acc ->
      Map.put(acc, letter, length)
    end) |> Enum.min_by(fn {_key, val} -> val end)
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

  @doc ~S"""

    iex> Day05.remove(String.codepoints("dabAcCaCBAcCcaDA"), "c")
    ["d", "a", "b", "A", "a", "B", "A", "a", "D", "A"]
    """
  def remove(codepoints, letter) do
    Enum.reject(codepoints, fn (x) -> letter == String.downcase(x) end)
  end
end
