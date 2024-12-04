defmodule Day2 do
  def pt1(inp) do
    reports = inp |> String.split("\n", trim: true)

    reports
    |> Enum.map(fn r ->
      r |> String.split(" ") |> Enum.map(&String.to_integer/1)
    end)
    |> Enum.filter(&checkSafe/1)
    |> Enum.count()
  end

  def checkSafe([x | tail]) do
    h = hd(tail)

    case x < h do
      false -> checkSafe([x | tail], :decreasing)
      true -> checkSafe([x | tail], :increasing)
    end
  end

  def checkSafe([_], _) do
    # one item left is always true
    true
  end

  def checkSafe([x | tail], :increasing) do
    h = hd(tail)

    # increasing so h-x should be positive if safe
    diff = h - x

    x < h && diff >= 1 && diff <= 3 && checkSafe(tail, :increasing)
  end

  def checkSafe([x | tail], :decreasing) do
    h = hd(tail)

    # decreasing so x-h should be positive if safe
    diff = x - h

    x > h && diff >= 1 && diff <= 3 && checkSafe(tail, :decreasing)
  end

  def pt2(inp) do
    reports = inp |> String.trim_trailing() |> String.split("\n")

    reports
    |> Enum.map(fn r ->
      r |> String.split(" ") |> Enum.map(&String.to_integer/1)
    end)
    |> Enum.filter(&checkSafeWithDampener/1)
    |> Enum.count()
  end

  def checkSafeWithDampener(report) do
    if checkSafe(report) do
      true
    else
      Enum.to_list(0..(length(report) - 1))
      |> Enum.any?(fn x ->
        report |> List.delete_at(x) |> checkSafe()
      end)
    end
  end
end
