defmodule Corex.AccountsTest do
  use Corex.DataCase

  alias Corex.Accounts
  alias Corex.Accounts.User
  alias Corex.Extra
  alias Corex.Test.Mom

  describe "list_users/0" do
    test "returns all users" do
      "user1" |> Mom.user_attrs |> Accounts.create_user
      "user2" |> Mom.user_attrs |> Accounts.create_user
      assert Accounts.list_users() |> Extra.Enum.tids() == ~w{user1 user2}
    end
  end

  describe "get_user" do
    setup do
      {:ok, user} = Mom.user_attrs("test") |> Accounts.create_user
      [user: user]
    end

    test "returns the user with given id", %{user: user} do
      assert Accounts.get_user!(user.id).tid == "test"
    end

    test "returns the user with the given email and password, if they are correct" do
      {:ok, user} = Accounts.get_user(email: "test@example.com", password: "password123")
      assert user.tid == "test"
    end

    test "returns :error if the given password is incorrect" do
      assert Accounts.get_user(email: "test@example.com", password: "WRONG!") == {:error, "invalid password"}
    end

    test "returns :error if the given email does not correspond to a user" do
      assert Accounts.get_user(email: "WRONG@example.com", password: "password123") == {:error, "user not found"}
    end
  end

  describe "create_user/1" do
    test "creates a user with valid data" do
      assert {:ok, %User{} = user} = Accounts.create_user(%{email: "foo@example.com", password: "password123"})
      assert user.email == "foo@example.com"
      assert user |> User.check_password("password123") == {:ok, user}
    end

    test "returns error changeset with invalid data" do
      assert {:error, %Ecto.Changeset{} = changeset} = Accounts.create_user(%{email: "bad", password: "short"})
      assert changeset.valid? == false
      assert changeset.errors[:email] == {"has invalid format", [validation: :format]}
    end
  end

  describe "update_user/2" do
    test "updates the user with valid data" do
      {:ok, user} = Accounts.create_user(%{email: "foo@example.com", password: "password123"})
      assert {:ok, %User{} = user} = Accounts.update_user(user, %{email: "new@example.com"})
      assert user.email == "new@example.com"
    end

    test "returns error changeset with invalid data" do
      {:ok, user} = Accounts.create_user(%{email: "foo@example.com", password: "password123"})
      assert {:error, %Ecto.Changeset{}} = Accounts.update_user(user, %{email: "bad"})
      assert user == Accounts.get_user!(user.id)
    end
  end

  describe "delete_user/1 " do
    test "deletes the user" do
      {:ok, user} = Mom.user_attrs |> Accounts.create_user()
      assert {:ok, %User{}} = Accounts.delete_user(user)
      assert_raise Ecto.NoResultsError, fn -> Accounts.get_user!(user.id) end
    end
  end

  describe "change_user/1" do
    test "returns a user changeset" do
      {:ok, user} = Mom.user_attrs |> Accounts.create_user()
      assert %Ecto.Changeset{} = Accounts.change_user(user)
    end
  end
end
