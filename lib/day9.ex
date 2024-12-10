defmodule Day9 do
  def pt1(inp) do
    {files, frees} = inp |> String.trim_trailing() |> parse()

    file_count = (files |> Enum.count()) - 1
    calc_checksum({files, 0, file_count}, frees, 0)
  end

  def pt2(inp) do
    {files, frees} = inp |> String.trim_trailing() |> parse()

    file_count = (files |> Enum.count()) - 1
    calc_checksum_whole({files, 0, file_count}, frees, 0)
  end

  defp sum_range(range, id) do
    range
    |> Enum.map(fn x -> x * id end)
    |> Enum.sum()
  end

  def calc_checksum(files, frees, acc, i \\ 0)

  def calc_checksum({:empty, _, _}, _, acc, _) do
    acc
  end

  def calc_checksum({files, _, _}, _, acc, _) when map_size(files) == 0,
    do: calc_checksum({:empty, 0, 0}, [], acc, 0)

  def calc_checksum({files, start, last}, [free | frees], acc, i) do
    len = files[start]

    files = Map.delete(files, start)

    acc_file =
      acc +
        (i..(len + i - 1) |> sum_range(start))

    {fs, last, acc_gap} = fill_gap({files, last}, free, i + len)

    calc_checksum({fs, start + 1, last}, frees, acc_file + acc_gap, len + i + free)
  end

  def calc_checksum({files, start, last}, [], acc, i) when map_size(files) > 0 do
    {id, len} = files[start]

    files = Map.delete(files, start)

    acc_file =
      acc +
        (i..(len + i - 1) |> sum_range(id))

    calc_checksum({files, start + 1, last}, [], acc_file, len + i)
  end

  def fill_gap(files, gap, i, acc \\ 0)
  def fill_gap({:empty, last}, _, _, acc), do: {%{}, last, acc}
  def fill_gap({files, last}, 0, _, acc), do: {files, last, acc}

  def fill_gap({files, last}, _, _, acc) when map_size(files) == 0,
    do: fill_gap({:empty, last}, 0, 0, acc)

  def fill_gap({files, last}, gap, i, acc) when map_size(files) > 0 do
    len = files[last]

    cond do
      gap < len ->
        fill_gap(
          {%{files | last => len - gap}, last},
          0,
          0,
          acc + (i..(i + gap - 1) |> sum_range(last))
        )

      gap >= len ->
        files = Map.delete(files, last)

        fill_gap(
          {files, last - 1},
          gap - len,
          i + len,
          acc + (i..(i + len - 1) |> sum_range(last))
        )
    end
  end

  def calc_checksum_whole(files, frees, acc, i \\ 0)

  def calc_checksum_whole({:empty, _, _}, _, acc, _) do
    acc
  end

  def calc_checksum_whole({files, _, _}, _, acc, _) when map_size(files) == 0,
    do: calc_checksum_whole({:empty, 0, 0}, [], acc, 0)

  def calc_checksum_whole({files, start, last}, [free | frees], acc, i) do
    len = files[start]

    files = Map.delete(files, start)

    acc_file =
      acc +
        (i..(len + i - 1) |> sum_range(start))

    {fs, last, acc_gap} = fill_gap({files, last}, free, i + len)

    calc_checksum_whole({fs, start + 1, last}, frees, acc_file + acc_gap, len + i + free)
  end

  def calc_checksum_whole({files, start, last}, [], acc, i) when map_size(files) > 0 do
    {id, len} = files[start]

    files = Map.delete(files, start)

    acc_file =
      acc +
        (i..(len + i - 1) |> sum_range(id))

    calc_checksum_whole({files, start + 1, last}, [], acc_file, len + i)
  end

  def fill_gap_whole(files, gap, i, acc \\ 0)
  def fill_gap_whole({:empty, last}, _, _, acc), do: {%{}, last, acc}
  def fill_gap_whole({files, last}, 0, _, acc), do: {files, last, acc}

  def fill_gap_whole({files, last}, _, _, acc) when map_size(files) == 0,
    do: fill_gap_whole({:empty, last}, 0, 0, acc)

  def fill_gap_whole({files, last}, gap, i, acc) when map_size(files) > 0 do
    len = files[last]

    cond do
      gap < len ->
        fill_gap_whole(
          {files, last - 1},
          gap,
          i,
          acc + (i..(i + gap - 1) |> sum_range(last))
        )

      gap == len ->
        files = Map.delete(files, last)
        {files, last - 1, acc}

      gap > len ->
        files = Map.delete(files, last)

        fill_gap_whole(
          {files, last - 1},
          gap - len,
          i + len,
          acc + (i..(i + len - 1) |> sum_range(last))
        )
    end
  end

  def parse(bin, acc \\ {[], []})

  def parse(<<file::1-binary, free::1-binary, rest::binary>>, {files, frees}) do
    parse(rest, {[String.to_integer(file) | files], [String.to_integer(free) | frees]})
  end

  def parse(<<file::1-binary>>, {files, frees}) do
    parse(<<>>, {[String.to_integer(file) | files], frees})
  end

  def parse(<<>>, {files, frees}) do
    {Enum.reverse(files)
     |> Enum.with_index(fn x, i -> {i, x} end)
     |> Enum.into(%{}), Enum.reverse(frees)}
  end
end
