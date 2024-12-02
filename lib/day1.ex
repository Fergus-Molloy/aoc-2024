defmodule Day1 do
  def pt1(inp) do
    {ls, rs} =
      inp
      |> String.trim()
      |> String.split("\n")
      |> Enum.map(&parseLine/1)
      |> Enum.unzip()

    sorted_ls = Enum.sort(ls)
    sorted_rs = Enum.sort(rs)

    Enum.zip_with(sorted_ls, sorted_rs, fn a, b -> if a > b, do: a - b, else: b - a end)
    |> Enum.sum()
  end

  def parseLine(line) do
    [ls, rs] =
      line
      |> String.split("   ")
      |> Enum.map(&Integer.parse/1)
      |> Enum.map(&elem(&1, 0))

    {ls, rs}
  end
end
