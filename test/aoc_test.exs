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

  test "Day 2 pt1" do
    {:ok, file} = File.read("./inputs/2")
    assert Day2.pt1(file) == 670
  end

  test "Day 2 pt2" do
    {:ok, file} = File.read("./inputs/2")
    assert Day2.pt2(file) == 700
  end

  test "Day 3 pt1 parser" do
    # single digit
    inp = "mul(1,2)"
    {:ok, out, _, _, _, _} = Day3.Parser.parse_pt1(inp)
    [1, 2] = :proplists.get_value(:mul, out)
    # max digits
    inp = "mul(123,234)"
    {:ok, out, _, _, _, _} = Day3.Parser.parse_pt1(inp)
    [123, 234] = :proplists.get_value(:mul, out)
    # multiple output
    inp = "mul(123,234)mul(1,2)"
    {:ok, [{:mul, [123, 234]}, {:mul, [1, 2]}], _, _, _, _} = Day3.Parser.parse_pt1(inp)
    # ignore symbols between
    inp = "mul(123,234)asdfasdfmul(1,2)"
    {:ok, [{:mul, [123, 234]}, {:mul, [1, 2]}], _, _, _, _} = Day3.Parser.parse_pt1(inp)
    # mix valid and invalid
    inp = "mul(123,234)asdmul(3!,12)asdfmul(1,2)"
    {:ok, [{:mul, [123, 234]}, {:mul, [1, 2]}], _, _, _, _} = Day3.Parser.parse_pt1(inp)
    # invalid symbol
    inp = "mul(!123,234)"
    {:ok, [], _, _, _, _} = Day3.Parser.parse_pt1(inp)
    # invalid num
    inp = "mul(1123,234)"
    {:ok, [], _, _, _, _} = Day3.Parser.parse_pt1(inp)
    # respect spacing
    inp = "mul(1123, 234)"
    {:ok, [], _, _, _, _} = Day3.Parser.parse_pt1(inp)
  end

  test "Day 3 pt2 parser" do
    # single digit
    inp = "do()"
    {:ok, [{:do, _}], _, _, _, _} = Day3.Parser.parse_pt2(inp)
    inp = "do()mul(1,2)don't()"
    {:ok, [{:do, _}, {:mul, [1, 2]}, {:dont, _}], _, _, _, _} = Day3.Parser.parse_pt2(inp)
    inp = "don't()"
    {:ok, [{:dont, _}], _, _, _, _} = Day3.Parser.parse_pt2(inp)
  end

  test "Day 3 pt1" do
    {:ok, file} = File.read("./inputs/3")
    assert Day3.pt1(file) == 185_797_128
  end

  test "Day 3 pt2" do
    {:ok, file} = File.read("./inputs/3")
    assert Day3.pt2(file) == 89_798_695
  end
end
