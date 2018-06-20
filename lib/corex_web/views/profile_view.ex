defmodule CorexWeb.ProfileView do
  use CorexWeb, :view

  alias Corex.Accounts.User
  alias CorexWeb.WidgetView
  alias CorexWeb.WidgetView.DetailTable

  def profile_table(%User{} = user, conn) do
    DetailTable.new(title: "Profile", role: "profile-detail-table", tid: user.tid)
    |> DetailTable.row("Email", user.email)
    |> WidgetView.widget(conn)
  end
end
