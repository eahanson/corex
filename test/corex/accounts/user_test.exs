defmodule Corex.Accounts.UserTest do
  use Corex.DataCase

  alias Corex.Accounts
  alias Corex.Accounts.User
  alias Corex.Test.Mom

  describe "check_password" do
    setup do
      {:ok, user} = Mom.user_attrs("test") |> Accounts.create_user
      [user: user]
    end

    test "returns the user if the password is correct", %{user: user} do
      {:ok, checked_user} = user |> User.check_password("password123")
      assert checked_user.tid == "test"
    end

    test "returns an error if the password is incorrect", %{user: user} do
      assert user |> User.check_password("WRONG") == {:error, "invalid password"}
    end

    test "returns an error if the user is nil" do
      assert nil |> User.check_password("password123") == {:error, "user not found"}
    end
  end
end
