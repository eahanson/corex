defmodule CorexWeb.AuthGuardsTest do
  use CorexWeb.ConnCase

  import CorexWeb.AuthGuards

  test "is_admin?" do
    assert_is_admin(:admin, true)
    assert_is_admin(:member, false)
    assert_is_admin(:guest, false)
    assert_is_admin("glorp", false)
    assert_is_admin(nil, false)
  end

  test "is_member?" do
    assert_is_member(:admin, true)
    assert_is_member(:member, true)
    assert_is_member(:guest, false)
    assert_is_member("glorp", false)
    assert_is_member(nil, false)
  end

  defp assert_is_admin(role, expected_result) do
    result =
      case role do
        role when is_admin?(role) -> true
        _ -> false
      end

    assert result == expected_result
  end

  defp assert_is_member(role, expected_result) do
    result =
      case role do
        role when is_member?(role) -> true
        _ -> false
      end

    assert result == expected_result
  end
end
