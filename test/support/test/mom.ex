defmodule Corex.Test.Mom do
  def admin_attrs(opts \\ []) do
    user_attrs("admin", opts |> Enum.into(%{admin: true}))
  end

  def user_attrs(tid, opts \\ []) do
    opts |> Enum.into(%{tid: tid, email: "#{tid}@example.com", password: "password123"})
  end
end
