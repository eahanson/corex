defmodule Corex.CLI.Doctor do
  alias Corex.Color
  alias Corex.CLI.Homebrew
  alias Corex.Extra

  def run do
    checks() |> Enum.all?(&run_check/1)
  end

  defp checks do
    homebrew_packages = Homebrew.packages()
    homebrew_services = Homebrew.services()

    [
      check(homebrew_packages, "elixir", version: "1.5"),
      check(homebrew_packages, "node"),
      check(homebrew_packages, "yarn"),
      check(homebrew_packages, "phantomjs"),
      check(homebrew_packages, "heroku", formula: "heroku/brew/heroku"),
      check(homebrew_packages, "postgresql"),
      check(homebrew_services, "postgresql"),
      check(:file, "assets/node_modules", remedy: "(cd assets && yarn install)")
    ]
  end

  defp check(_, _, opts \\ %{})

  defp check(%Homebrew.Packages{} = packages, package, opts) do
    {
      [package, opts[:version], "is installed"] |> Extra.Enum.compact |> Enum.join(" "),
      fn -> packages |> Homebrew.installed?(package, opts) end,
      "brew install #{opts[:formula] || package}"
    }
  end

  defp check(:file, file, opts) do
    {
      "File/directory '#{file}' exists",
      fn -> File.exists?(file) end,
      opts[:remedy]
    }
  end

  defp check(%Homebrew.Services{} = services, service, _opts) do
    {
      "#{service} is running",
      fn -> services |> Homebrew.running?(service) end,
      "brew services start #{service}"
    }
  end

  defp run_check({description, command, remedy}) do
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
