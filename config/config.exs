# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :corex,
  ecto_repos: [Corex.Repo]

# Configures the endpoint
config :corex, CorexWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "v0PbqDW4SohoXUXup/7Od+3Ng6K6R69kLEkaY8qtBmi/2G4DZLbzUns0fEPDH3QV",
  render_errors: [view: CorexWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Corex.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
