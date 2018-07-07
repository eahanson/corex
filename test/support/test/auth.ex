defmodule Corex.Test.Auth do
  use Plug.Test

  import ExUnit.Assertions

  alias Corex.Test
  alias TableRex.Table

  def assert_auth(conn, minimum_allowed_user_level, fun) do
    results = check_auth(conn, minimum_allowed_user_level, fun)

    unless results |> Enum.all?(fn [_, _, _, success?] -> success? end) do
      Table.new(results, ["User Level", "Expected", "Actual", "OK?"])
      |> Table.render!(horizontal_style: :off, vertical_style: :off)
      |> flunk()
    end
  end

  def check_auth(conn, :guest, fun), do: check_auth(conn, ~w{guest member admin}a, fun)
  def check_auth(conn, :member, fun), do: check_auth(conn, ~w{member admin}a, fun)
  def check_auth(conn, :admin, fun), do: check_auth(conn, ~w{admin}a, fun)

  def check_auth(conn, allowed_user_levels, fun) when is_list(allowed_user_levels) do
    ~w{guest member admin}a
    |> Enum.map(fn user_level ->
      case {user_level in allowed_user_levels, get_status(conn, user_level, fun)} do
        {true, {:success, status}} -> [user_level, "2xx, 3xx", status, true]
        {false, {:success, status}} -> [user_level, "4xx, 5xx", status, false]
        {true, {:failure, status}} -> [user_level, "2xx, 3xx", status, false]
        {false, {:failure, status}} -> [user_level, "4xx, 5xx", status, true]
      end
    end)
  end

  defp get_status(conn, user_level, fun) do
    status =
      try do
        conn
        |> Test.Session.login_as(user_level)
        |> fun.()
        |> Map.get(:status)
      rescue
        Phoenix.ActionClauseError -> 400
      end

    if status in 200..399 do
      {:success, status}
    else
      {:failure, status}
    end
  end
end
