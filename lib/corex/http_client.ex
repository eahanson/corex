defmodule Corex.HttpClient do
  def get(url, headers \\ []) do
    HTTPoison.get!(url, headers)
    |> Map.get(:body)
  end
end
