defmodule CorexWeb.Test.Pages.Login do
  use Wallaby.DSL

  import Corex.Test.Assertions
  import Wallaby.Query, only: [button: 1, text_field: 1]

  def submit_form(session, email: email, password: password) do
    session
    |> fill_in(text_field("Email"), with: email)
    |> fill_in(text_field("Password"), with: password)
    |> click(button("Continue"))
  end

  def assert_errors(session, errors) do
    found =
      session
      |> all(Query.css("[data-role=error-message]"))
      |> Enum.reduce(%{}, fn elem, acc ->
        acc
        |> Map.put(
          Wallaby.Element.attr(elem, "data-for") |> String.to_atom(),
          Wallaby.Element.text(elem)
        )
      end)

    assert_eq(found, errors |> Enum.into(%{}))

    session
  end
end
