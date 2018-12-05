defmodule Day03 do
  alias Day03.LineParser
  alias Day03.Claim

  @default_path "./var/input.txt"
  def run(path \\ @default_path) do
    path
    |> build
    |> claim_squares(%{})
    |> Map.values
    |> Enum.filter(&(Enum.count(&1) > 1))
    |> Enum.count
  end

  def find_not_overlapped(path \\ @default_path) do
    claims = build(path)
    ids = Enum.map(claims, &(&1.id))

    fabric = claims |> claim_squares(%{})

    Enum.reduce(Map.to_list(fabric), ids, fn ({_point, elves_ids}, all_ids) ->
      case Enum.count(elves_ids) do
        0 -> all_ids
        1 -> all_ids
        _ -> Enum.reject(all_ids, fn (id) -> Enum.any?(elves_ids, &(&1 == id)) end)
      end
    end)
    |> hd
  end

  def build(path) do
    File.stream!(path)
    |> Stream.map(&String.trim/1)
    |> Stream.map(&LineParser.parse/1)
    |> Enum.map(&Claim.build/1)
  end

  def claim_squares([], fabric) do
    fabric
  end

  def claim_squares([claim|claims], fabric) do
    fabric = Enum.reduce(Day03.Claim.range_x(claim), fabric, fn (x, fab) ->
      Enum.reduce(Day03.Claim.range_y(claim), fab, fn(y, fb) ->
        key = {x, y}

        fb
        |> Map.put_new(key, [])
        |> Map.update!(key, fn acc -> [claim.id|acc] end)
      end)
    end)

    claim_squares(claims, fabric)
  end
end
