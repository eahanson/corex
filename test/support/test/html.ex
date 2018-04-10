defmodule CorexWeb.Test.HTML do
  def text(html_string, css_query) do
    html_string |> Floki.find(css_query) |> Floki.text()
  end

  def table_contents(html_string, css_query) do
    html_string
    |> Floki.find(css_query)
    |> Floki.raw_html()
    |> Floki.find("tr")
    |> Enum.map(fn row ->
      row
      |> Floki.find("th, td")
      |> Enum.map(fn cell -> Floki.text(cell, sep: " ") end)
      |> Enum.map(fn s -> String.replace(s, ~r{\s+}, " ") end)
    end)
  end

  def html(html_string, css_query) do
    html_string |> Floki.find(css_query) |> Enum.map(fn node -> node |> Floki.raw_html() end)
  end

  def attr(html_string, css_query, attr_name) do
    html_string |> Floki.attribute(css_query, attr_name)
  end
end
