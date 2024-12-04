defmodule Day3 do
  def pt1(inp) do
    {:ok, out, _, _, _, _} = Day3.Parser.parse_pt1(inp)

    out
    |> Enum.map(fn {_, [a, b]} ->
      a * b
    end)
    |> Enum.sum()
  end

  def pt2(inp) do
    {:ok, out, _, _, _, _} = Day3.Parser.parse_pt2(inp)

    out
    |> Enum.reduce(
      0,
      fn {:mul, [a, b]}, acc -> acc + a * b end
    )
  end

  defmodule Parser do
    import NimbleParsec

    parseMul =
      ignore(string("mul("))
      |> integer(min: 1, max: 3)
      |> ignore(string(","))
      |> integer(min: 1, max: 3)
      |> ignore(string(")"))
      |> tag(:mul)

    parseDont =
      string("don't()")
      |> eventually(string("do()"))

    defparsec(
      :parse_pt1,
      repeat(eventually(parseMul))
    )

    defparsec(
      :parse_pt2,
      repeat(
        choice([
          parseMul,
          ignore(parseDont),
          ignore(utf8_char([]))
        ])
      )
    )
  end
end
