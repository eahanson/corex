defmodule Corex.Presence do
  def is_blank?(nil), do: true
  def is_blank?(s) when is_binary(s), do: String.length(s) == 0
  def is_blank?(l) when is_list(l), do: length(l) == 0
  def is_blank?(m) when is_map(m), do: map_size(m) == 0
  def is_blank?(_), do: false
end
