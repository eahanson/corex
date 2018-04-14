defmodule Corex.Mixfile do
  use Mix.Project

  def project do
    [
      app: :corex,
      version: "0.0.1",
      elixir: "~> 1.6.0",
      elixirc_paths: elixirc_paths(Mix.env),
      compilers: [:phoenix, :gettext] ++ Mix.compilers,
      start_permanent: Mix.env == :prod,
      aliases: aliases(),
      deps: deps(),
      escript: escript(),
    ]
  end

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application do
    [
      mod: {Corex.Application, []},
      extra_applications: [
        :logger,
        :phoenix_slime,
        :runtime_tools,
        :timex,
      ]
    ]
  end

  def escript do
    [main_module: Corex.CLI, name: "cli", app: nil, path: "./bin/cli"]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_),     do: ["lib"]

  # Specifies your project dependencies.
  #
  # Type `mix help deps` for examples and options.
  defp deps do
    [
      {:apex, "~> 1.2"},
      {:briefly, "~> 0.3", only: :test},
      {:comeonin, "~> 4.1"},
      {:cowboy, "~> 1.0"},
      {:floki, "~> 0.20.1"},
      {:gettext, "~> 0.11"},
      {:junit_formatter, git: "https://github.com/sparta-science/junit-formatter.git", only: :test},
      {:pbkdf2_elixir, "~> 0.12.3"},
      {:phoenix, "~> 1.3.0"},
      {:phoenix_ecto, "~> 3.2"},
      {:phoenix_html, "~> 2.10"},
      {:phoenix_live_reload, "~> 1.0", only: :dev},
      {:phoenix_pubsub, "~> 1.0"},
      {:phoenix_slime, "~> 0.9.0"},
      {:postgrex, ">= 0.0.0"},
      {:progress_bar, "~> 1.6"},
      {:table_rex, "~> 1.0"},
      {:timex, "~> 3.0"},
      {:wallaby, "~> 0.19.1", [runtime: false, only: :test]}
    ]
  end

  # Aliases are shortcuts or tasks specific to the current project.
  # For example, to create, migrate and run the seeds file at once:
  #
  #     $ mix ecto.setup
  #
  # See the documentation for `Mix` for more info on aliases.
  defp aliases do
    [
      "assets.compile": &compile_assets/1,
      "ecto.setup": ["ecto.create", "ecto.migrate", "run priv/repo/seeds.exs"],
      "ecto.reset": ["ecto.drop", "ecto.setup"],
      "test": ["assets.compile --quiet", "ecto.create --quiet", "ecto.migrate", "test"]
    ]
  end

  defp compile_assets(_) do
    Mix.shell.cmd("assets/node_modules/brunch/bin/brunch build assets/")
  end
end
