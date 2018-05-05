defmodule CorexWeb.Test.Pages.Login do
  use Wallaby.DSL

  import Wallaby.Query, only: [button: 1, text_field: 1]

  def submit_form(session, email: email, password: password) do
    session
    |> fill_in(text_field("Email"), with: email)
    |> fill_in(text_field("Password"), with: password)
    |> click(button("Continue"))
  end
end
