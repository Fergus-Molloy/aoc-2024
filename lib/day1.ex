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
    |> String.split("\n", trim: true)
    |> Enum.map(&parseLine/1)
    |> Enum.unzip()
  end

  def parseLine(line) do
    line
    |> split()
  end

  def split(<<l::5-binary, _::3-binary, r::binary>>),
    do: {String.to_integer(l), String.to_integer(r)}

  def pt2(inp) do
    {ls, rs} = inp |> parse()

    grouped =
      rs
      |> Enum.group_by(fn x -> x end)
      |> Enum.map(fn {k, v} -> {k, length(v)} end)
      |> Enum.into(%{})

    ls |> Enum.reduce(0, fn l, acc -> acc + l * Map.get(grouped, l, 0) end)
  end
end
