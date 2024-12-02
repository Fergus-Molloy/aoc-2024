defmodule AocTest do
  use ExUnit.Case

  test "Day 1 pt1" do
    {:ok, file} = File.read("./inputs/1")
    assert Day1.pt1(file) == 2_164_381
  end

  test "Day 1 pt2" do
    {:ok, file} = File.read("./inputs/1")
    assert Day1.pt2(file) == 20_719_933
  end
end
