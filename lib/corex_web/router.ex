defmodule CorexWeb.Router do
  use CorexWeb, :router

  pipeline :browser do
    plug(:accepts, ["html"])
    plug(:fetch_session)
    plug(:fetch_flash)
    plug(:protect_from_forgery)
    plug(:put_secure_browser_headers)
  end

  pipeline :api do
    plug(:accepts, ["json"])
  end

  scope "/", CorexWeb do
    pipe_through(:browser)

    get("/", LandingController, :index)
    resources("/profile", ProfileController, singleton: true)
    resources("/session", SessionController, singleton: true)
    resources("/users", UserController)
  end

  # Other scopes may use custom stacks.
  # scope "/api", CorexWeb do
  #   pipe_through :api
  # end
end
