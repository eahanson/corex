defmodule Corex.CLI.DoctorConfig do
  import Corex.CLI.Doctor, only: [check: 2, check: 3]

  alias Corex.CLI.Homebrew

  def checks() do
    homebrew_packages = Homebrew.packages()
    homebrew_services = Homebrew.services()

    [
      phoenix_checks(homebrew_packages),
      heroku_checks(homebrew_packages),
      postgres_checks(homebrew_packages, homebrew_services)
    ]
  end

  defp phoenix_checks(homebrew_packages) do
    [
      check(homebrew_packages, "elixir", version: "1.5"),
      check(homebrew_packages, "node"),
      check(homebrew_packages, "yarn"),
      check(homebrew_packages, "phantomjs"),
      check(:file, "assets/node_modules", remedy: "(cd assets && yarn install)")
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
