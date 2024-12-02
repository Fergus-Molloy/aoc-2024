defmodule Aoc do
  @moduledoc """
  This module provides helpers that are used across multiple days.
  """

  @doc """
  Drops the last element of a list, reversing the list in the process
  """
  def dropLast(list), do: list |> Enum.reverse() |> tl()
end
