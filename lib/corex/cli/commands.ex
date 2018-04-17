defmodule Corex.CLI.Commands do
  alias Corex.CLI

  def command(name) do
    command(name, nil)
  end

  def command("", _) do
    command("help")
  end

  def command("help", _) do
    CLI.IO.table [
      ["help", "This message"],
      ["doctor", "Check that everything is working"],
      ["shipit", "Update, run tests and push"],
      ["server", "Run the server"],
      ["status", "Check the status"],
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
    command("doctor") and
    CLI.exec("Running server", "iex", ["-S", "mix", "phx.server"])
  end

  def command("shipit", _) do
    command("update") and
    command("test") and
    command("git", ["push"])
  end

  def command("status", opts) do
    success? = CLI.exec("Status", &CLI.CircleCI.run/0)

    case {success?, !!opts[:fail_on_negative_status]} do
      {true, _} -> true
      {false, true} -> false
      {false, false} -> true
    end
  end

  def command("test", _) do
    CLI.exec("Running tests", "mix", ["test", "--color"])
  end

  def command("update", _) do
    command("git", ["pull"]) and
    command("migrate") and
    command("doctor") and
    command("status", fail_on_negative_status: false)
  end

  def command(_, _) do
    command("help", nil)
  end
end
