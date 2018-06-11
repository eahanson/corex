defmodule Corex.Mixfile do
  use Mix.Project

  def project do
    [
      app: :corex,
      version: "0.0.1",
      elixir: "~> 1.6.0",
      elixirc_paths: elixirc_paths(Mix.env()),
      compilers: [:phoenix, :gettext] ++ Mix.compilers(),
      start_permanent: Mix.env() == :prod,
      aliases: aliases(),
      deps: deps(),
      escript: escript()
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
        :httpoison,
        :phoenix_slime,
        :runtime_tools,
        :timex,
        :tzdata
      ]
    ]
  end

  def escript do
    [main_module: Corex.CLI, name: "cli", app: nil, path: "./bin/cli"]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

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
      {:httpoison, "~> 0.12"},
      {:junit_formatter, github: "sparta-science/junit-formatter", only: :test},
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
      {:tzdata, "== 0.1.8", override: true},
      {:wallaby, "~> 0.19",
       github: "keathley/wallaby",
       ref: "fb7bb0e2150f367f87f4dd9b7e3093a7613baa89",
       runtime: false,
       only: :test}
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
      test: [
        "test.phantom_limit",
        "assets.compile --quiet",
        "ecto.create --quiet",
        "ecto.migrate",
        "test"
      ],
      "test.phantom_limit": &check_phantom_limit/1
    ]
  end

  defp compile_assets(_) do
    Mix.shell().cmd("assets/node_modules/brunch/bin/brunch build assets/")
  end

  defp check_phantom_limit(_) do
    if Mix.shell().cmd("ps aux | grep -vq grep | grep -icq phantom") == 0 do
      raise "Phantoms are running. Try: killall -m phantomjs"
    end
  end
end
