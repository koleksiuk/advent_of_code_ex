defmodule Day01 do
  alias Day01.Device
  require IEx

  @moduledoc """
  Documentation for Day01.
  """

  @doc """
  Hello world.

  ## Examples

      iex> Day01.hello()
      :world

  """

  def run do
    File.stream!("./var/input.txt")
    |> sum
  end

  def run2 do
    File.stream!("./var/input2.txt")
    |> find_repeated_frequencies
  end


  def sum(stream) do
    stream
    |> prepare_stream
    |> Enum.sum
  end

  def find_repeated_frequencies(stream) do
    stream
    |> prepare_stream
    |> Stream.cycle
    |> Enum.reduce_while({0, MapSet.new([0])}, fn num, {current_frequency, seen_frequencies} ->
      new_frequency = current_frequency + num

      if new_frequency in seen_frequencies do
        {:halt, new_frequency}
      else
        {:cont, {new_frequency, MapSet.put(seen_frequencies, new_frequency)}}
      end
    end)
  end

  defp prepare_stream(stream) do
    stream
    |> Stream.map(&String.trim/1)
    |> Stream.map(&Device.parse_frequency/1)
  end
end
