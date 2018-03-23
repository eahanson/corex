defmodule Corex.Extra.Enum do
  alias Corex.Presence

  def compact(enum) do
    enum |> Enum.reject(&(is_nil(&1)))
  end

  def compact_blank(enum) do
    enum |> compact |> Enum.reject(&(Presence.is_blank?(&1)))
  end

  def at!(enum, index) do
    if length(enum) < (index + 1) do
      raise "Out of range: index #{index} of enum with length #{length(enum)}: #{inspect(enum)}"
    else
      Enum.at(enum, index)
    end
  end

  def tids(enumerable) do
    enumerable |> Enum.map(fn (e) -> e.tid end)
  end
end
