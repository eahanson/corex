defmodule Corex.CLI.Doctor do
  alias Corex.Color
  alias Corex.CLI.Homebrew
  alias Corex.CLI.DoctorConfig
  alias Corex.Extra

  def run do
    DoctorConfig.checks() |> List.flatten() |> Enum.all?(&run_check/1)
  end

  def check(_, _, opts \\ %{})

  def check(%Homebrew.Packages{} = packages, package, opts) do
    {
      [package, opts[:version], "is installed"] |> Extra.Enum.compact |> Enum.join(" "),
      fn -> packages |> Homebrew.installed?(package, opts) end,
      "brew install #{opts[:formula] || package}"
    }
  end

  def check(:file, file, opts) do
    {
      "file/directory '#{file}' exists",
      fn -> File.exists?(file) end,
      opts[:remedy]
    }
  end

  def check(%Homebrew.Services{} = services, service, _opts) do
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
