defmodule Day04.LineParser do
  import NimbleParsec

  # [1518-09-20 00:43] falls asleep

  date =
    ignore(string("["))
    |> integer(4)
    |> ignore(string("-"))
    |> integer(2)
    |> ignore(string("-"))
    |> integer(2)

  time =
    integer(2)
    |> ignore(string(":"))
    |> integer(2)

  action =
    utf8_string([], min: 1)

  defparsec :line,
    date
    |> ignore(string(" "))
    |> concat(time)
    |> ignore(string("] "))
    |> concat(action)

  defparsec :guard_start,
    ignore(string("Guard #"))
    |> integer(min: 1, max: 4)
    |> ignore(string(" begins shift"))

  @doc ~S"""

  iex> Day04.LineParser.line("[1518-09-20 00:43] falls asleep")
  [1518, 9, 20, 0, 43, "falls asleep"]
  """

  def parse_line(raw_line) do
    {:ok, line, _, _, _, _} = __MODULE__.line(raw_line)

    [year, month, day, hour, minute, performed_action] = line

    {:ok, datetime} = NaiveDateTime.new(year, month, day, hour, minute, 0)

    action = parse_action(performed_action)

    {datetime, action}
  end

  defp parse_action(performed_action) do
    case performed_action do
      "falls asleep" -> :sleep
      "wakes up" -> :wake_up
      _ ->
        {:ok, [guard_id], _, _, _, _x} = Day04.LineParser.guard_start(performed_action)
        {:new, guard_id}
    end
  end
end
