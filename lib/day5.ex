defmodule Day5 do
  defstruct rules: [], page_sets: []

  def pt1(inp) do
    parsed = Day5.Parser.parse(inp)

    rules =
      parsed.rules
      |> Enum.group_by(fn [b, _] -> b end, fn [_, a] -> a end)

    parsed.page_sets
    |> Enum.filter(fn set ->
      set |> Enum.reverse() |> inOrder(rules)
    end)
    |> Enum.map(fn set ->
      l = length(set)
      Enum.at(set, Kernel.div(l, 2))
    end)
    |> Enum.sum()
  end

  def pt2(inp) do
    parsed = Day5.Parser.parse(inp)

    rules = parsed.rules |> Enum.group_by(fn [b, _] -> b end, fn [_, a] -> a end)

    parsed.page_sets
    |> Enum.filter(fn set ->
      !(set |> Enum.reverse() |> inOrder(rules))
    end)
    |> Enum.map(fn pages ->
      pages
      |> Enum.sort(fn a, b ->
        case Map.get(rules, a) do
          nil -> false
          rs -> Enum.member?(rs, b)
        end
      end)
      |> Enum.at(length(pages) |> Kernel.div(2))
    end)
    |> Enum.sum()
  end

  @doc """
  Checks if there's any rule stating that p must be before the list. 
  Expects list to be in reverse order.
  """
  def inOrder([_], _), do: true

  def inOrder([p | before], rules) do
    correctlyPlaced(p, before, rules) && inOrder(before, rules)
  end

  defp correctlyPlaced(page, before, m) do
    case Map.get(m, page) do
      nil -> true
      as -> as |> Enum.all?(&(!Enum.member?(before, &1)))
    end
  end

  defmodule Parser do
    import NimbleParsec

    rule =
      integer(min: 1)
      |> ignore(ascii_char(~c"|"))
      |> integer(min: 1)
      |> ignore(ascii_char(~c"\n"))
      |> tag(:rule)

    page =
      repeat(
        integer(min: 1)
        |> ignore(optional(ascii_char(~c",")))
      )
      |> tag(:page)

    defparsec(:parse_rules, repeat(rule))
    defparsec(:parse_page, page)

    def parse(inp) do
      {:ok, rules, rest, _, _, _} = parse_rules(inp)

      pages = parse_pages(rest)

      Enum.concat(rules, pages)
      %Day5{rules: rules |> Enum.map(&elem(&1, 1)), page_sets: pages |> Enum.map(&elem(&1, 1))}
    end

    def parse_pages(inp) do
      inp
      |> String.split("\n", trim: true)
      |> Enum.map(fn l ->
        {:ok, [out], _, _, _, _} =
          Day5.Parser.parse_page(l)

        out
      end)
    end
  end
end
