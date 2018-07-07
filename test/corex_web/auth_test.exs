defmodule CorexWeb.AuthTest do
  use CorexWeb.ConnCase

  alias Corex.Test

  describe "check_auth" do
    test "admin with success status" do
      assert do_check_auth(:admin, 200) == [
               [:guest, "300-599", 200, false],
               [:member, "300-599", 200, false],
               [:admin, "200-299", 200, true]
             ]
    end

    test "admin with failure status" do
      assert do_check_auth(:admin, 400) == [
               [:guest, "300-599", 400, true],
               [:member, "300-599", 400, true],
               [:admin, "200-299", 400, false]
             ]
    end

    test "member with success status" do
      assert do_check_auth(:member, 200) == [
               [:guest, "300-599", 200, false],
               [:member, "200-299", 200, true],
               [:admin, "200-299", 200, true]
             ]
    end

    test "member with failure status" do
      assert do_check_auth(:member, 500) == [
               [:guest, "300-599", 500, true],
               [:member, "200-299", 500, false],
               [:admin, "200-299", 500, false]
             ]
    end

    test "guest with success status" do
      assert do_check_auth(:guest, 200) == [
               [:guest, "200-299", 200, true],
               [:member, "200-299", 200, true],
               [:admin, "200-299", 200, true]
             ]
    end

    test "guest with failure status" do
      assert do_check_auth(:guest, 500) == [
               [:guest, "200-299", 500, false],
               [:member, "200-299", 500, false],
               [:admin, "200-299", 500, false]
             ]
    end
  end

  defp do_check_auth(minimum_allowed_user_level, status) do
    Test.Auth.check_auth(build_conn(:get, "/"), minimum_allowed_user_level, fn _ -> %{status: status} end)
  end
end
