defmodule AocBench do
  def main do
    {:ok, day1} = File.read("./inputs/1")
    {:ok, day2} = File.read("./inputs/2")
    {:ok, day3} = File.read("./inputs/3")
    {:ok, day4} = File.read("./inputs/4")
    {:ok, day5} = File.read("./inputs/5")
    {:ok, day9} = File.read("./inputs/9")

    benches = [
      {"Day 1 pt 1", fn -> Day1.pt1(day1) end},
      {"Day 1 pt 2", fn -> Day1.pt2(day1) end},
      {"Day 2 pt 1", fn -> Day2.pt1(day2) end},
      {"Day 2 pt 2", fn -> Day2.pt2(day2) end},
      {"Day 3 pt 1", fn -> Day3.pt1(day3) end},
      {"Day 3 pt 2", fn -> Day3.pt2(day3) end},
      {"Day 4 pt 1", fn -> Day4.pt1(day4) end},
      {"Day 4 pt 2", fn -> Day4.pt2(day4) end},
      {"Day 5 pt 1", fn -> Day5.pt1(day5) end},
      {"Day 5 pt 2", fn -> Day5.pt2(day5) end},
      {"Day 9 pt 1", fn -> Day9.pt1(day9) end}
    ]

    options = [
      formatters: [{Benchee.Formatters.Console, comparison: false}, Benchee.Formatters.HTML]
      # profile_after: true
      # save: [path: "benchmarks/aoc.benchee", tag: "all"]
      # load: ["benchmarks/aoc.benchee"]
    ]

    args = System.argv()

    if length(args) == 0 || hd(args) == "all" do
      IO.puts(IO.ANSI.format([:cyan, :underline, "Running all days\n"]))

      Benchee.run(
        Enum.into(benches, %{}),
        options
      )
    else
      x = hd(args)
      parsed = Integer.parse(x)

      if parsed != :error do
        {d, _} = parsed
        IO.puts(IO.ANSI.format([:cyan, :underline, "Running day " <> x <> "\n"]))

        Benchee.run(
          benches
          |> Enum.filter(fn {name, _} ->
            [_, day | _] = name |> String.split(" ")

            String.to_integer(day) == d
          end)
          |> Enum.into(%{}),
          options
        )
      else
        IO.puts("Could not parse day to run: " <> x)
      end
    end
  end
end

AocBench.main()
