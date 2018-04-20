defmodule Corex.HttpClient do
  def get(url, headers \\ []) do
    HTTPoison.get!(url, headers)
    |> Map.get(:body)
    |> trace("get", url, headers, false)
  end
  
  defp trace(response, method, url, headers, enabled?) do
    message = ["[HttpClient]", method, url, headers |> inspect, response] |> List.flatten |> Enum.join(" ")
    if enabled?, do: message |> IO.puts()

    response
  end
end
