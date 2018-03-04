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

  defp info(executable) do
    {result, status} = System.cmd("brew", ["info", "--json=v1", "-installed", executable], stderr_to_stdout: true)

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
end
