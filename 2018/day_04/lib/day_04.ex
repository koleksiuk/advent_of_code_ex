defmodule Day04 do
  alias Day04.LineParser

  @default_path "./priv/input.txt"
  def run(path \\ @default_path) do
    {:ok, pid} = Day04.Guard.start_link
    path
    |> build
    |> Enum.each(fn {timestamp, action} ->
      case action do
        :sleep -> Day04.Guard.sleep(pid, timestamp)
        :wake_up -> Day04.Guard.wake_up(pid, timestamp)
        {:new, id} -> Day04.Guard.new(pid,id)
      end
    end)

    sleeptimes = Day04.Guard.sleeptimes(pid)

  {most_sleeps_id, mins} = Enum.max_by(sleeptimes, fn {_id, vals} ->
      Enum.count(vals)
    end)

    {most_frequent_min, _vals} = mins
    |> Enum.group_by(&(&1))
    |> Enum.max_by(fn {_min, vals} -> Enum.count(vals) end)

    most_frequent_min * most_sleeps_id
  end

  def run2(path \\ @default_path) do
    {:ok, pid} = Day04.Guard.start_link
    path
    |> build
    |> Enum.each(fn {timestamp, action} ->
      case action do
        :sleep -> Day04.Guard.sleep(pid, timestamp)
        :wake_up -> Day04.Guard.wake_up(pid, timestamp)
        {:new, id} -> Day04.Guard.new(pid,id)
      end
    end)

    sleeptimes = Day04.Guard.sleeptimes(pid)

    {id, min, _count} =sleeptimes |>
      Enum.map(fn {id, mins} ->
        {min, vals}=Enum.group_by(mins, &(&1)) |> Enum.max_by(fn {_min, vals} -> Enum.count(vals) end)

        {id, min, Enum.count(vals)}
      end)
      |> Enum.max_by(fn {_id, _min, count} -> count end)

    id * min
  end

  def build(path) do
    File.stream!(path)
    |> Stream.map(&String.trim/1)
    |> Stream.map(&LineParser.parse_line/1)
    |> Enum.sort_by(&compare_line/1)
    |> Enum.map(fn x -> x end)

  end

  def compare_line({datetime, _}) do
    NaiveDateTime.to_erl(datetime)
  end
end
