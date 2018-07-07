# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Corex.Repo.insert!(%Corex.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

alias Corex.Accounts

%{email: "admin@example.com", password: "password123", admin: true} |> Accounts.create_admin()
%{email: "user@example.com", password: "password123", admin: false} |> Accounts.create_user()
