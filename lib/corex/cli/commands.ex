defmodule Corex.CLI.Commands do
  alias Corex.CLI

  def command("", _) do
    command("help", nil)
  end

  def command("help", _) do
    CLI.IO.table [
      ["help", "This message"],
      ["doctor", "Check that everything is working"],
      ["shipit", "Update, run tests and push"],
      ["server", "Run the server"],
      ["test", "Run tests"],
      ["update", "Pull, migrate, and run doctor"],
    ]
  end

  def command("doctor", _) do
    CLI.exec("Doctor", &CLI.Doctor.run/0)
  end

  def command("git", ["pull"]) do
    CLI.exec("Pulling git", "git", ["pull", "--rebase"])
  end

  def command("git", ["push"]) do
    CLI.exec("Pushing git", "git", ["push"])
  end

  def command("migrate", _) do
    CLI.exec("Migrating", "mix", ["ecto.migrate", "ecto.dump"])
  end

  def command("server", _) do
    command("doctor", nil) and
    CLI.exec("Running server", "iex", ["-S", "mix", "phx.server"])
  end

  def command("shipit", _) do
    command("update", nil) and
    command("test", nil) and
    command("git", ["push"])
  end

  def command("test", _) do
    CLI.exec("Running tests", "mix", ["test", "--color"])
  end

  def command("update", _) do
    command("git", ["pull"]) and
    command("migrate", nil) and
    command("doctor", nil)
  end
end
