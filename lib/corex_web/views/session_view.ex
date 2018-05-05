defmodule CorexWeb.SessionView do
  use CorexWeb, :view

  alias CorexWeb.WidgetView
  alias CorexWeb.WidgetView.Form

  def login_form(user, conn, action: action, title: title) do
    Form.new(user, action: action, title: title)
    |> Form.text_input(:email)
    |> Form.password_input(:password)
    |> WidgetView.widget(conn)
  end
end
