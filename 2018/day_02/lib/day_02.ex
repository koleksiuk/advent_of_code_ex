defmodule Day02 do
  def checksum() do
    File.stream!("./var/input.txt")
    |> Stream.map(&String.trim/1)
    |> Stream.map(fn str -> check(str) end)
    |> Enum.reduce({0, 0}, fn (checked_string, {doubles, triples}) ->
      case checked_string do
      { _, true, true} -> { doubles + 1, triples + 1 }
      { _, true, false} -> { doubles + 1, triples }
      { _, false, true} -> { doubles, triples + 1 }
      _ -> { doubles, triples }
      end
    end)
    |> (fn({doubles, triples}) -> doubles * triples end).()
  end

  @doc ~S"""

  iex> Day02.check("abcdef")
  { "abcdef", false, false }

  iex> Day02.check("bababc")
  { "bababc", true, true }

  iex> Day02.check("abbcde")
  { "abbcde", true, false }

  iex> Day02.check("abcccd")
  { "abcccd", false, true }

  iex> Day02.check("aabcdd")
  { "aabcdd", true, false }

  iex> Day02.check("ababab")
  { "ababab", false, true }
  """
  def check(string) do
    String.codepoints(string)
    |> group_letters
    |> Map.values
    |> fetch_details(string)
  end

  def fetch_details(values, string) do
    {string, has_double?(values), has_triple?(values)}
  end

  def has_double?(values) do
    Enum.any?(values, &(&1 == 2))
  end

  def has_triple?(values) do
    Enum.any?(values, &(&1 == 3))
  end

  def group_letters(letters) do
    group_letters(%{}, letters)
  end

  def group_letters(map, []) do
    map
  end

  def group_letters(map, [letter|letters]) do
    group_letters(map, letter, letters)
  end

  def group_letters(map, letter, letters) do
    count = Map.get(map, letter, 0)

    group_letters(Map.put(map, letter, count + 1), letters)
  end
end
