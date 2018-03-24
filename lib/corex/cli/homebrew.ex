defmodule Corex.CLI.Homebrew do
  defmodule Packages do
    defstruct [:installed]
  end

  defmodule Services do
    defstruct [:all]
  end

  def packages(cmd \\ &run_cmd/2) do
    with {result, 0} <- cmd.("brew", ["info", "--json=v1", "--installed"]),
         {:ok, decoded} <- result |> Poison.decode,
         installed <- decoded |> Enum.map(fn package -> {package["name"], package["linked_keg"]} end) do
      %Packages{installed: installed}
    end
  end

  def services(cmd \\ &run_cmd/2) do
    with {result, 0} <- cmd.("brew", ["services", "list"]),
         [_headers | lines] <- result |> String.split("\n"),
         lists <- lines |> Enum.map(&String.split/1),
         valid_lists <- lists |> Enum.reject(fn list -> length(list) < 2 end),
         tuples <- valid_lists |> Enum.map(fn [name | [status | _rest]] -> {name, status} end) do
      %Services{all: tuples}
    end
  end

  def installed?(packages, package_name, opts \\ %{}) do
    case packages.installed |> find_by_name(package_name) do
      nil ->
        false

      {_name, version} ->
        if opts[:version] do
          version |> String.starts_with?(opts[:version])
        else
          true
        end
    end
  end

  def running?(services, service_name) do
    case services.all |> find_by_name(service_name) do
      nil -> false
      {_name, "started"} -> true
      _ -> false
    end
  end

  defp find_by_name(tuples, expected_name) do
    tuples |> Enum.find(fn {name, _} -> name == expected_name end)
  end

  defp run_cmd(command, args) do
    System.cmd(command, args, stderr_to_stdout: true)
  end
end
