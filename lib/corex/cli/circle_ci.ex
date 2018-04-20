defmodule Corex.CLI.CircleCI do
  alias Corex.CLI
  alias Corex.HttpClient

  def run() do
    success? = CLI.IO.spinner "Circle CI", &status/0

    case success? do
      true ->
        "Circle CI passed" |> IO.puts
        true

      false ->
        "Circle CI failed. Try: open #{url()}" |> IO.puts
        false
    end
  end

  def status do
    failed? = request() |> parse()
    !failed?
  end

  def url do
    "https://circleci.com/gh/eahanson/corex"
  end

  def request() do
    {:ok, _} = Application.ensure_all_started(:httpoison)
    token = System.get_env("CIRCLE_CI_TOKEN")
    HttpClient.get(
      "https://circleci.com/api/v1.1/project/github/eahanson/corex?limit=1&circle-token=#{token}",
      ["Accept": "application/json"]
    )
  end

  def parse(response) do
    response |> Poison.decode!() |> hd() |> Map.get("failed")
  end
end
