defmodule Day9 do
  def pt1(inp) do
    {files, frees} = inp |> String.trim_trailing() |> parse()

    calc_checksum(files, frees, 0)
  end

  defp sum_range(range, id) do
    range
    |> Enum.map(fn x -> x * id end)
    |> Enum.sum()
  end

  def calc_checksum(files, frees, acc, i \\ 0)

  def calc_checksum([], _, acc, _) do
    acc
  end

  def calc_checksum([{id, len} | files], [free | frees], acc, i) do
    acc_file =
      acc +
        (i..(len + i - 1) |> sum_range(id))

    {fs, acc_gap} = fill_gap(Enum.reverse(files), free, i + len)

    calc_checksum(Enum.reverse(fs), frees, acc_file + acc_gap, len + i + free)
  end

  def calc_checksum([{id, len} | files], [], acc, i) do
    acc_file =
      acc +
        (i..(len + i - 1) |> sum_range(id))

    calc_checksum(files, [], acc_file, len + i)
  end

  def fill_gap(files, gap, i, acc \\ 0)
  def fill_gap([], _, _, acc), do: {[], acc}
  def fill_gap(files, 0, _, acc), do: {files, acc}

  def fill_gap([{id, len} | files], gap, i, acc) do
    cond do
      gap < len ->
        fill_gap([{id, len - gap} | files], 0, 0, acc + (i..(i + gap - 1) |> sum_range(id)))

      gap >= len ->
        fill_gap(files, gap - len, i + len, acc + (i..(i + len - 1) |> sum_range(id)))
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
    {Enum.reverse(files) |> Enum.with_index(fn x, i -> {i, x} end), Enum.reverse(frees)}
  end
end
