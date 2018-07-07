defmodule CorexWeb.AuthTest do
  use CorexWeb.ConnCase

  alias Corex.Test

  describe "check_auth" do
    test "admin with success status" do
      assert do_check_auth(:admin, 200) == [
               [:guest, "4xx, 5xx", 200, false],
               [:member, "4xx, 5xx", 200, false],
               [:admin, "2xx, 3xx", 200, true]
             ]
    end

    test "admin with failure status" do
      assert do_check_auth(:admin, 400) == [
               [:guest, "4xx, 5xx", 400, true],
               [:member, "4xx, 5xx", 400, true],
               [:admin, "2xx, 3xx", 400, false]
             ]
    end

    test "member with success status" do
      assert do_check_auth(:member, 200) == [
               [:guest, "4xx, 5xx", 200, false],
               [:member, "2xx, 3xx", 200, true],
               [:admin, "2xx, 3xx", 200, true]
             ]
    end

    test "member with failure status" do
      assert do_check_auth(:member, 500) == [
               [:guest, "4xx, 5xx", 500, true],
               [:member, "2xx, 3xx", 500, false],
               [:admin, "2xx, 3xx", 500, false]
             ]
    end

    test "guest with success status" do
      assert do_check_auth(:guest, 200) == [
               [:guest, "2xx, 3xx", 200, true],
               [:member, "2xx, 3xx", 200, true],
               [:admin, "2xx, 3xx", 200, true]
             ]
    end

    test "guest with failure status" do
      assert do_check_auth(:guest, 500) == [
               [:guest, "2xx, 3xx", 500, false],
               [:member, "2xx, 3xx", 500, false],
               [:admin, "2xx, 3xx", 500, false]
             ]
    end
  end

  defp do_check_auth(minimum_allowed_user_level, status) do
    Test.Auth.check_auth(build_conn(:get, "/"), minimum_allowed_user_level, fn _ -> %{status: status} end)
  end
end
