defmodule Day4 do
  @spec pt1(binary()) :: integer()
  def pt1(inp) do
    # look for horizontal XMAS'
    split = inp |> String.split("\n", trim: true)

    hs =
      split
      |> Enum.map(fn l ->
        String.to_charlist(l)
        |> Enum.chunk_every(4, 1, :discard)
        |> Enum.filter(fn
          ~c'XMAS' -> true
          ~c'SAMX' -> true
          _ -> false
        end)
        |> Enum.count()
      end)
      |> Enum.sum()

    vs =
      split
      |> Enum.map(&String.to_charlist/1)
      |> transpose()
      |> Enum.map(fn l ->
        Enum.chunk_every(l, 4, 1, :discard)
        |> Enum.filter(fn
          ~c'XMAS' -> true
          ~c'SAMX' -> true
          _ -> false
        end)
        |> Enum.count()
      end)
      |> Enum.sum()

    dd =
      split
      |> Enum.chunk_every(4, 1, :discard)
      |> Enum.map(fn cs ->
        Enum.map(cs, &String.to_charlist/1)
        |> transpose()
        |> Enum.chunk_every(4, 1, :discard)
        |> Enum.map(fn l ->
          case {matchDiagDown(l), matchDiagUp(l)} do
            {true, true} -> 2
            {false, true} -> 1
            {true, false} -> 1
            _ -> 0
          end
        end)
        |> Enum.sum()
      end)
      |> Enum.sum()

    vs + hs + dd
  end

  def pt2(inp) do
    inp
    |> String.split("\n", trim: true)
    |> Enum.chunk_every(3, 1, :discard)
    |> Enum.map(fn cs ->
      Enum.map(cs, &String.to_charlist/1)
      |> transpose()
      |> Enum.chunk_every(3, 1, :discard)
      |> Enum.filter(fn
        [
          [77, _, 77],
          [_, 65, _],
          [83, _, 83] | _
        ] ->
          true

        [
          [83, _, 77],
          [_, 65, _],
          [83, _, 77] | _
        ] ->
          true

        [
          [83, _, 83],
          [_, 65, _],
          [77, _, 77] | _
        ] ->
          true

        [
          [77, _, 83],
          [_, 65, _],
          [77, _, 83] | _
        ] ->
          true

        _ ->
          false
      end)
      |> Enum.count()
    end)
    |> Enum.sum()
  end

  defp transpose(l), do: l |> Enum.zip_with(&Function.identity/1)

  defp matchDiagDown([
         [83, _, _, _],
         [_, 65, _, _],
         [_, _, 77, _],
         [_, _, _, 88] | _
       ]),
       do: true

  defp matchDiagDown([
         [88, _, _, _],
         [_, 77, _, _],
         [_, _, 65, _],
         [_, _, _, 83] | _
       ]),
       do: true

  defp matchDiagDown(_), do: false

  defp matchDiagUp([
         [_, _, _, 83],
         [_, _, 65, _],
         [_, 77, _, _],
         [88, _, _, _] | _
       ]),
       do: true

  defp matchDiagUp([
         [_, _, _, 88],
         [_, _, 77, _],
         [_, 65, _, _],
         [83, _, _, _] | _
       ]),
       do: true

  defp matchDiagUp(_), do: false
end
