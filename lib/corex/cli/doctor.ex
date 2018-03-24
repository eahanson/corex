defmodule Corex.CLI.Doctor do
  alias Corex.Color
  alias Corex.CLI.Homebrew

  def run do
    checks() |> Enum.all?(&check/1)
  end

  defp checks do
    [
      check_homebrew("elixir"),
      check_homebrew_version("elixir", "1.5"),
      check_homebrew("node"),
      check_homebrew("yarn"),
      check_homebrew("phantomjs"),
      check_homebrew("heroku", "heroku/brew/heroku"),
      check_homebrew("postgresql"),
      check_homebrew_service("postgresql"),
      check_file_exists("Javascript/Yarn/Brunch is set up", "assets/node_modules", "(cd assets && yarn install)")
    ]
  end

  defp check_homebrew(executable, formula \\ nil) do
    {
      "#{executable} is installed",
      fn -> Homebrew.installed?(executable) end,
      "brew install #{formula || executable}"
    }
  end

  defp check_homebrew_version(executable, version_prefix) do
    {
      "version #{version_prefix}.x of #{executable} is installed",
      fn -> Homebrew.version?(executable, version_prefix) end,
      "brew info #{executable}"
    }
  end

  defp check_homebrew_service(service) do
    {
      "#{service} is running",
      fn -> Homebrew.running?(service) end,
      "brew services start #{service}"
    }
  end

  defp check_file_exists(description, file, remedy) do
    {
      description,
      fn -> File.exists?(file) end,
      remedy
    }
  end

  defp check({description, command, remedy}) do
    "Checking: " <> description <> "... " |> Color.write(:cyan)

    success? = command.()

    if success? do
      "OK" |> Color.puts(:green)
    else
      [
        {"FAILED\n", :red},
        {"     Try: ", :cyan},
        {remedy, :yellow},
        {" (it's in the clipboard)", :cyan}
      ] |> Color.puts
      remedy |> pbcopy()
    end

    success?
  end

  defp pbcopy(s) do
    "echo \"#{s}\" | pbcopy" |> String.to_charlist |> :os.cmd
  end
end
