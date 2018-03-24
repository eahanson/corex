defmodule Corex.Extra.String do
  def surround(s, prefix_and_suffix) do
    surround(s, prefix_and_suffix, prefix_and_suffix)
  end

  def surround(s, prefix, suffix) do
    prefix <> s <> suffix
  end

  def inner_truncate(s, length) do
    if String.length(s) <= length do
      s
    else
      "#{String.slice(s, 0..9)}…#{String.slice(s, -10..-1)}"
    end
  end
end
