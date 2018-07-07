defmodule Corex.Accounts.UserTest do
  use Corex.DataCase

  alias Corex.Accounts
  alias Corex.Accounts.User
  alias Corex.Test.Mom

  describe "check_password" do
    setup do
      {:ok, user} = Mom.user_attrs("test") |> Accounts.create_user()
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

  describe "role" do
    test "guest when user is nil", do: assert(User.role(nil) == :guest)
    test "guest when user has no id", do: assert(User.role(%User{id: nil}) == :guest)
    test "member when user has id and admin is false", do: assert(User.role(%User{id: 49, admin: false}) == :member)
    test "member when user has id and admin is nil", do: assert(User.role(%User{id: 49, admin: nil}) == :member)
    test "admin when user has id and admin is true", do: assert(User.role(%User{id: 49, admin: true}) == :admin)
  end

  describe "admin" do
    test "user can be an admin" do
      {:ok, user} = Mom.admin_attrs() |> Accounts.create_admin()
      assert user.admin == true
    end
  end
end
