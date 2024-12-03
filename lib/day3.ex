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
    |> IO.inspect()
    |> Enum.reduce(
      {0, :do},
      fn
        {:mul, [a, b]}, {acc, enabled} when enabled == :do -> {acc + a * b, enabled}
        {:mul, _}, {acc, enabled} -> {acc, enabled}
        {:do, _}, {acc, _} -> {acc, :do}
        {:dont, _}, {acc, _} -> {acc, :dont}
      end
    )
    |> elem(0)
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

    parseDo =
      ignore(string("do()"))
      |> tag(:do)

    parseDont =
      ignore(string("don't()"))
      |> tag(:dont)

    defparsec(
      :parse_pt1,
      repeat(
        choice([
          parseMul,
          ignore(utf8_char([]))
        ])
      )
    )

    defparsec(
      :parse_pt2,
      repeat(
        choice([
          parseMul,
          parseDo,
          parseDont,
          ignore(utf8_char([]))
        ])
      )
    )
  end
end
