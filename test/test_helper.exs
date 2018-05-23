Application.put_env(:wallaby, :base_url, CorexWeb.Endpoint.url)
{:ok, _} = Application.ensure_all_started(:wallaby)

ExUnit.configure formatters: [JUnitFormatter, ExUnit.CLIFormatter]
ExUnit.start

Ecto.Adapters.SQL.Sandbox.mode(Corex.Repo, :manual)

Application.put_env(:wallaby, :base_url, CorexWeb.Endpoint.url)
