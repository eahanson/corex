defmodule Corex.CLI.Homebrew do
  def installed?(executable) do
    case info(executable) do
      {:installed, _version} -> true
      {:not_installed} -> false
    end
  end

  def version?(executable, version_prefix) do
    case info(executable) do
      {:installed, version} -> version |> String.starts_with?(version_prefix)
      {:not_installed} -> false
    end
  end

  def running?(service, cmd \\ &run_cmd/2) do
    {result, status} = cmd.("brew", ["services", "list"])

    if status == 0 do
      [_headers | service_infos] = result |> String.split("\n")

      service_info =
        service_infos
        |> Enum.map(&String.split/1)
        |> Enum.reject(fn list -> length(list) < 2 end)
        |> Enum.map(fn [name | [status | _rest]] -> {name, status} end)
        |> Enum.find(fn {name, _} -> name == service end)

      case service_info do
        {_, "started"} -> true
        _ -> false
      end
    end
  end

  defp info(executable) do
    {result, status} = run_cmd("brew", ["info", "--json=v1", executable])

    if status == 0 do
      [parsed] = result |> decode_json()
      version = parsed |> Map.get("installed") |> hd |> Map.get("version")
      {:installed, version}
    else
      {:not_installed}
    end
  end

  def decode_json(s) do
    s
    |> String.split("\n")
    |> Enum.map(&Poison.decode/1)
    |> Enum.find(fn {status, _} -> status == :ok end)
    |> elem(1)
  end

  defp run_cmd(command, args) do
    System.cmd(command, args, stderr_to_stdout: true)
  end
end
