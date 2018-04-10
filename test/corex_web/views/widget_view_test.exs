defmodule CorexWeb.WidgetViewTest do
  use CorexWeb.ConnCase, async: true

  alias Corex.Accounts.User

  alias CorexWeb.Test
  alias CorexWeb.WidgetView
  alias CorexWeb.WidgetView.DataTable
  alias CorexWeb.WidgetView.Form

  describe "widget %DataTable{}" do
    defp render(widget) do
      rendered =
        WidgetView.widget(widget, build_conn(:get, "/"))
        |> Phoenix.HTML.safe_to_string()

      "#{rendered}\n"
    end

    defp text(widget, css_query) do
      widget |> render() |> Test.HTML.text(css_query)
    end

    defp table_contents(widget, css_query) do
      widget |> render() |> Test.HTML.table_contents(css_query)
    end

    defp html(widget, css_query) do
      widget |> render() |> Test.HTML.html(css_query)
    end

    defp attr(widget, css_query, attr) do
      widget |> render() |> Test.HTML.attr(css_query, attr)
    end

    setup do
      cars = [
        %{make: "Toyota", model: "Corolla", color: "red"},
        %{make: "Honda", model: "Civic", color: "blue"},
      ]

      data_table =
        DataTable.new(cars, title: "Some Cars")
        |> DataTable.column("Make", fn car -> car.make end)
        |> DataTable.column("Model", &(&1.model))
        |> DataTable.column("Color", :color)
        |> DataTable.column("VIN", "N/A")
        |> DataTable.action("Show", fn car -> "/cars/#{car.make}/#{car.model}" end)
        |> DataTable.action("Delete", fn car -> "/cars/#{car.make}/#{car.model}" end, :delete, fn car -> "Really delete #{car.make}?" end)
        |> DataTable.table_action("New Car", "/cars/new")
        |> DataTable.table_action("Help", "/help")

      [data_table: data_table]
    end

    test "renders a table with a title", %{data_table: data_table} do
      assert data_table |> text("table.data-table .data-table__title .data-table__title-text") == "Some Cars"
    end

    test "renders data", %{data_table: data_table} do
      assert data_table |> table_contents("table.data-table") == [
        ["Some Cars New Car Help"],
        ["Make", "Model", "Color", "VIN", ""],
        ["Toyota", "Corolla", "red", "N/A", "Show Delete"],
        ["Honda", "Civic", "blue", "N/A", "Show Delete"],
      ]
    end

    test "renders action links", %{data_table: data_table} do
      links = data_table |> html("table.data-table tbody td .data-table__buttons a")
      assert links |> Enum.at(0) =~ ~r|<a class="data-table__button" data-confirm="" href="/cars/Toyota/Corolla">Show</a>|
      assert links |> Enum.at(1) =~ ~r|<a class="data-table__button--delete" data-confirm="Really delete Toyota\?" data-csrf=".*" data-method="delete" data-to="/cars/Toyota/Corolla" href="#" rel="nofollow">Delete</a>|
      assert links |> Enum.at(2) =~ ~r|<a class="data-table__button" data-confirm="" href="/cars/Honda/Civic">Show</a>|
      assert links |> Enum.at(3) =~ ~r|<a class="data-table__button--delete" data-confirm="Really delete Honda\?" data-csrf=".*" data-method="delete" data-to="/cars/Honda/Civic" href="#" rel="nofollow">Delete</a>|
    end

    test "renders table action links", %{data_table: data_table} do
      assert data_table |> html("table.data-table thead a") == [
        ~s|<a class="data-table__title-button" href="/cars/new">New Car</a>|,
        ~s|<a class="data-table__title-button" href="/help">Help</a>|,
      ]
    end
  end

  describe "widget %Form{}" do
    setup do
      user = %User{email: "email@example.com", password: ""} |> User.changeset(%{})

      form =
        Form.new(user, action: "/user/create", title: "Edit User")
        |> Form.text_input(:email)
        |> Form.password_input(:password)

      [form: form]
    end

    test "renders a form", %{form: form} do
      assert form |> attr("form", "action") == ["/user/create"]
    end
  end
end
