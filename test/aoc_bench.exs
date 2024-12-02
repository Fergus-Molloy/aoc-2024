defmodule AocBench do
  {:ok, day1} = File.read("./inputs/1")
  {:ok, day2} = File.read("./inputs/2")

  Benchee.run(
    %{
      "Day 1 pt 1" => fn -> Day1.pt1(day1) end,
      "Day 1 pt 2" => fn -> Day1.pt2(day1) end,
      "Day 2 pt 1" => fn -> Day2.pt1(day2) end,
      "Day 2 pt 2" => fn -> Day2.pt2(day2) end
    },
    formatters: [{Benchee.Formatters.Console, comparison: false}],
    load: ["_build/benches/aoc.benchee"]
  )
end
