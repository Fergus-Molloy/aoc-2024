defmodule AocTest do
  use ExUnit.Case

  @tag day: 1
  test "Day 1 pt1" do
    {:ok, file} = File.read("./inputs/1")
    assert Day1.pt1(file) == 2_164_381
  end

  @tag day: 1
  test "Day 1 pt2" do
    {:ok, file} = File.read("./inputs/1")
    assert Day1.pt2(file) == 20_719_933
  end

  @tag day: 2
  test "Day 2 pt1" do
    {:ok, file} = File.read("./inputs/2")
    assert Day2.pt1(file) == 670
  end

  @tag day: 2
  test "Day 2 pt2" do
    {:ok, file} = File.read("./inputs/2")
    assert Day2.pt2(file) == 700
  end

  test "Day 3 pt1 parser" do
    # single digit
    inp = "mul(1,2)"
    assert {:ok, out, _, _, _, _} = Day3.Parser.parse_pt1(inp)
    assert [1, 2] = :proplists.get_value(:mul, out)
    # max digits
    inp = "mul(123,234)"
    assert {:ok, out, _, _, _, _} = Day3.Parser.parse_pt1(inp)
    assert [123, 234] = :proplists.get_value(:mul, out)
    # multiple output
    inp = "mul(123,234)mul(1,2)"
    assert {:ok, [{:mul, [123, 234]}, {:mul, [1, 2]}], _, _, _, _} = Day3.Parser.parse_pt1(inp)
    # ignore symbols between
    inp = "mul(123,234)asdfasdfmul(1,2)"
    assert {:ok, [{:mul, [123, 234]}, {:mul, [1, 2]}], _, _, _, _} = Day3.Parser.parse_pt1(inp)
    # mix valid and invalid
    inp = "mul(123,234)asdmul(3!,12)asdfmul(1,2)"
    assert {:ok, [{:mul, [123, 234]}, {:mul, [1, 2]}], _, _, _, _} = Day3.Parser.parse_pt1(inp)
    # invalid symbol
    inp = "mul(!123,234)"
    assert {:ok, [], _, _, _, _} = Day3.Parser.parse_pt1(inp)
    # invalid num
    inp = "mul(1123,234)"
    assert {:ok, [], _, _, _, _} = Day3.Parser.parse_pt1(inp)
    # respect spacing
    inp = "mul(1123, 234)"
    assert {:ok, [], _, _, _, _} = Day3.Parser.parse_pt1(inp)
  end

  test "Day 3 pt2 parser" do
    # single digit
    inp = "do()mul(1,2)don't()"
    assert {:ok, [{:mul, [1, 2]}], _, _, _, _} = Day3.Parser.parse_pt2(inp)
    inp = "don't()mul(1,2)do()mul(3,4)"
    assert {:ok, [{:mul, [3, 4]}], _, _, _, _} = Day3.Parser.parse_pt2(inp)
  end

  @tag day: 3
  test "Day 3 pt1" do
    {:ok, file} = File.read("./inputs/3")
    assert Day3.pt1(file) == 185_797_128
  end

  @tag day: 3
  test "Day 3 pt2" do
    {:ok, file} = File.read("./inputs/3")
    assert Day3.pt2(file) == 89_798_695
  end

  test "Day 4 pt1 sample" do
    {:ok, file} = File.read("./inputs/4_sample_1")
    assert Day4.pt1(file) == 18
  end

  test "Day 4 pt2 sample" do
    {:ok, file} = File.read("./inputs/4_sample_2")
    assert Day4.pt2(file) == 9
  end

  @tag day: 4
  test "Day 4 pt1" do
    {:ok, file} = File.read("./inputs/4")
    assert Day4.pt1(file) == 2573
  end

  @tag day: 4
  test "Day 4 pt2" do
    {:ok, file} = File.read("./inputs/4")
    assert Day4.pt2(file) == 1850
  end

  @tag day: 5
  test "Day 5 rule parsing" do
    {:ok, file} = File.read("./inputs/5_sample_1")
    assert {:ok, out, rest, _, _, _} = Day5.Parser.parse_rules(file)
    assert [{:rule, [47, 53]}, {:rule, [97, 13]} | _] = out

    assert "\n75,47,61,53,29\n97,61,53,29,13\n75,29,13\n75,97,47,61,53\n61,13,29\n97,13,75,29,47\n" =
             rest

    assert [{:page, [75, 47, 61, 53, 29]} | _] = Day5.Parser.parse_pages(rest)

    parsed = Day5.Parser.parse(file)
    %Day5{:rules => [[47, 53] | _]} = parsed
    %Day5{:page_sets => [[75, 47, 61, 53, 29] | _]} = parsed
  end

  test "Day 5 pt1 sample" do
    {:ok, file} = File.read("./inputs/5_sample_1")
    assert Day5.pt1(file) == 143
  end

  test "Day 5 pt2 sample" do
    {:ok, file} = File.read("./inputs/5_sample_1")
    assert Day5.pt2(file) == 123
  end

  @tag day: 5
  test "Day 5 pt1" do
    {:ok, file} = File.read("./inputs/5")
    assert Day5.pt1(file) == 4569
  end

  @tag day: 5
  test "Day 5 pt2" do
    {:ok, file} = File.read("./inputs/5")
    assert Day5.pt2(file) == 6456
  end
end
