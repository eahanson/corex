defmodule Corex.Extra.Enum do
  alias Corex.Presence

  def compact(enum) do
    enum |> Enum.reject(&(is_nil(&1)))
  end

  def compact_blank(enum) do
    enum |> compact |> Enum.reject(&(Presence.is_blank?(&1)))
  end
end
