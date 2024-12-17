defmodule Day16 do
  def pt1(inp) do
    map = parse(inp)
    l_y = inp |> String.split("\n", trim: true) |> length()

    [l] =
      inp |> String.split("\n", trim: true) |> Stream.map(&String.to_charlist/1) |> Enum.take(1)

    l_x = length(l)

    [{s_y, s_x}] =
      for {coord, c} <- map, c == 83, do: coord

    IO.inspect({s_x, s_y})

    find_end([{s_x, s_y}], map, {l_x, l_y})
  end

  def find_end([], _, _) do
    :error
  end

  def find_end([{p_x, p_y} | rest] = stack, map, {l_x, l_y} = lims) do
    IO.inspect(stack)
    c = Map.get(map, {p_x, p_y}) |> IO.inspect()
    IO.inspect(c)

    case c do
      69 ->
        true

      35 ->
        find_end(rest, map, lims)

      _ ->
        hs = for xs <- (p_x - 1)..(p_x + 1), xs >= 0 && xs < l_x && xs && p_x, do: {xs, p_y}
        vs = for ys <- (p_y - 1)..(p_y + 1), ys >= 0 && ys < l_y && ys && p_y, do: {p_x, ys}
        find_end(hs ++ vs ++ rest, map, lims)
    end
  end

  def parse(inp) do
    inp
    |> String.split("\n", trim: true)
    |> Enum.map(fn l ->
      String.to_charlist(l)
      |> Enum.with_index()
    end)
    |> Enum.reduce({%{}, 0}, fn l, {o, y} ->
      {Enum.reduce(l, o, fn {c, x}, m ->
         Map.put(m, {x, y}, c)
       end), y + 1}
    end)
  end
end
