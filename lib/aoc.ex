defmodule Aoc do
  def main do
    {:ok, file} = File.read("./inputs/1")
    result = Day1.pt1(file)
    IO.puts("Day 1 pt1: " <> Integer.to_string(result))
  end
end
