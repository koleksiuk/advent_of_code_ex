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

  def find_key_letters do
    File.stream!("./var/input.txt")
    |> Stream.map(&String.trim/1)
    |> Enum.map(&(&1))
    |> find_best_matching_string()
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

  defp fetch_details(values, string) do
    {string, has_double?(values), has_triple?(values)}
  end

  defp has_double?(values) do
    Enum.any?(values, &(&1 == 2))
  end

  defp has_triple?(values) do
    Enum.any?(values, &(&1 == 3))
  end

  defp group_letters(letters) do
    group_letters(%{}, letters)
  end

  defp group_letters(map, []) do
    map
  end

  defp group_letters(map, [letter|letters]) do
    group_letters(map, letter, letters)
  end

  defp group_letters(map, letter, letters) do
    count = Map.get(map, letter, 0)

    group_letters(Map.put(map, letter, count + 1), letters)
  end

  defp find_best_matching_string([]) do
    nil
  end

  defp find_best_matching_string([string|strings]) do
    case find_similar(string, strings) do
      nil -> find_best_matching_string(strings)
      matched_string -> get_matched_letters(string, matched_string)
    end
  end

  @doc ~S"""

  iex> Day02.find_similar("abcd", ["accc", "abba", "aacd"])
  "aacd"

  iex> Day02.find_similar("abcd", ["accc", "abba", "abce"])
  "abce"

  iex> Day02.find_similar("abcd", ["abee"])
  nil

  iex> Day02.find_similar("abcd", ["accc", "aaaa", "dcba"])
  nil
  """
  def find_similar(string, strings) do
    Enum.find(strings, fn (str) ->
      similar_letters = get_matched_letters(string, str) |> String.length

      similar_letters == String.length(string) - 1
    end)
  end

  @doc ~S"""

  iex> Day02.get_matched_letters("abcd", "abce")
  "abc"

  iex> Day02.get_matched_letters("abcdefg", "abcdefg")
  "abcdefg"

  iex> Day02.get_matched_letters("abdefg", "abcdefg")
  "abdefg"

  iex> Day02.get_matched_letters("abdd", "abcd")
  "abd"

  """

  def get_matched_letters(string, str) do
    String.myers_difference(string, str)
    |> Keyword.get_values(:eq)
    |> Enum.join
  end
end
