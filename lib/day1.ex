defmodule Day1 do
  def pt1(inp) do
    {ls, rs} =
      inp
      |> parse()

    sorted_ls = Enum.sort(ls)
    sorted_rs = Enum.sort(rs)

    Enum.zip_with(sorted_ls, sorted_rs, fn a, b -> if a > b, do: a - b, else: b - a end)
    |> Enum.sum()
  end

  def parse(inp) do
    inp
    |> String.trim()
    |> String.split("\n")
    |> Enum.map(&parseLine/1)
    |> Enum.unzip()
  end

  def parseLine(line) do
    line
    |> String.to_charlist()
    |> split()
  end

  def split([l1, l2, l3, l4, l5, 32, 32, 32, r1, r2, r3, r4, r5]),
    do: {List.to_integer([l1, l2, l3, l4, l5]), List.to_integer([r1, r2, r3, r4, r5])}

  def pt2(inp) do
    {ls, rs} = inp |> parse()

    ls |> Enum.map(fn l -> l * Enum.count(rs, fn x -> x == l end) end) |> Enum.sum()
  end
end
