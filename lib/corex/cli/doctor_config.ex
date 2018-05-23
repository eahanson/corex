defmodule Corex.CLI.DoctorConfig do
  import Corex.CLI.Doctor, only: [check: 2, check: 3]

  alias Corex.CLI

  def checks() do
    homebrew_packages = CLI.IO.spinner "Loading Homebrew packages", fn -> CLI.Homebrew.packages() end
    homebrew_services = CLI.IO.spinner "Loading Homebrew services", fn -> CLI.Homebrew.services() end

    [
      phoenix_checks(homebrew_packages),
      heroku_checks(homebrew_packages),
      postgres_checks(homebrew_packages, homebrew_services)
    ]
  end

  defp phoenix_checks(homebrew_packages) do
    [
      check(homebrew_packages, "elixir", version: "1.6"),
      check(homebrew_packages, "node"),
      check(homebrew_packages, "yarn"),
      check(:file, "assets/node_modules", remedy: "(cd assets && yarn install)"),
      check(:which, "phantomjs", remedy: "npm install -g phantomjs-prebuilt")
    ]
  end

  defp heroku_checks(homebrew_packages) do
    [
      check(homebrew_packages, "heroku", formula: "heroku/brew/heroku"),
    ]
  end

  defp postgres_checks(homebrew_packages, homebrew_services) do
    [
      check(homebrew_packages, "postgresql"),
      check(homebrew_services, "postgresql"),
    ]
  end
end
