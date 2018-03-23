defmodule Corex.Extra.String do
  def surround(s, surrounder) do
    surround(s, surrounder, surrounder)
  end

  def surround(s, beginning, ending) do
    beginning <> s <> ending
  end

  def inner_truncate(s, length) do
    if String.length(s) <= length do
      s
    else
      "#{String.slice(s, 0..9)}…#{String.slice(s, -10..-1)}"
    end
  end
end
