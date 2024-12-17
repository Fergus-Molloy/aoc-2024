defmodule Day11 do
  def pt1(inp) do
    stones = parse(inp)

    blink(stones |> Enum.to_list(), 25)
    |> Stream.map(&elem(&1, 1))
    |> Enum.sum()
  end

  def pt2(inp) do
    stones = parse(inp)

    blink(stones |> Enum.to_list(), 75)
    |> Stream.map(&elem(&1, 1))
    |> Enum.sum()
  end

  def blink(stones, n \\ 1, rules \\ %{})

  def blink(stones, 0, _) do
    stones
  end

  def blink(stones, n, rules) do
    {new_stones, rules} = apply_rules(stones, rules, %{})

    blink(new_stones |> Enum.to_list(), n - 1, rules)
  end

  def apply_rules([], rules, acc) do
    {acc, rules}
  end

  def apply_rules([{stone, count} | stones], rules, acc) do
    {result, rules} =
      case Map.fetch(rules, stone) do
        {:ok, r} ->
          {r, rules}

        :error ->
          r = apply_rule(stone)
          rules = Map.put(rules, stone, r)
          {r, rules}
      end

    apply_rules(stones, rules, update_map(acc, result, count))
  end

  def update_map(acc, [a, b], count) do
    acc =
      case Map.fetch(acc, a) do
        {:ok, c} -> %{acc | a => c + count}
        _ -> Map.put(acc, a, count)
      end

    case Map.fetch(acc, b) do
      {:ok, c} -> %{acc | b => c + count}
      _ -> Map.put(acc, b, count)
    end
  end

  def update_map(acc, a, count) do
    case Map.fetch(acc, a) do
      {:ok, c} -> %{acc | a => c + count}
      _ -> Map.put(acc, a, count)
    end
  end

  def apply_rule(stone) do
    case stone do
      0 ->
        1

      stone ->
        s = Integer.to_string(stone)

        case s do
          x when rem(byte_size(x), 2) == 0 ->
            mid = div(byte_size(x), 2)
            l = binary_part(x, 0, mid) |> String.to_integer()
            r = binary_part(x, mid, mid) |> String.to_integer()
            [l, r]

          _ ->
            stone * 2024
        end
    end
  end

  def parse(inp) do
    inp
    |> String.trim_trailing()
    |> String.split(" ")
    |> Enum.map(fn x -> {String.to_integer(x), 1} end)
    |> Enum.into(%{})
  end
end
