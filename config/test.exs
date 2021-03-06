use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :corex, CorexWeb.Endpoint,
  http: [port: 4001],
  server: true

# Print only warnings and errors during test
config :logger, level: :warn

# Configure your database
config :corex, Corex.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "postgres",
  password: "postgres",
  database: "corex_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox

config :junit_formatter,
  report_file: "results.xml",
  report_dir: "_build",
  print_report_file: true

config :pbkdf2_elixir, rounds: 1

config :corex, :sql_sandbox, true
