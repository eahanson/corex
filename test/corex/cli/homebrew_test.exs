defmodule Corex.CLI.HomebrewTest do
  use Corex.SimpleCase, async: true

  alias Corex.CLI.Homebrew

  describe "packages" do
    test "returns package info" do
      info = Homebrew.packages(fn (_, _) -> {File.read!("test/support/fixtures/homebrew_info.json"), 0} end)
      assert info.installed |> List.first == {"autoconf", "2.69"}
    end
  end

  describe "services" do
    test "returns service info" do
      result = """
        Name       Status  User Plist
        postgresql stopped
        mysql      started erik /Users/erik/Library/LaunchAgents/homebrew.mxcl.mysql.plist
      """

      info = Homebrew.services(fn (_, _) -> {result, 0} end)
      assert info.all == [
          {"postgresql", "stopped"},
          {"mysql", "started"}
        ]
    end
  end

  describe "running?" do
    setup do
      [services: %Homebrew.Services{all: [{"postgresql", "stopped"}, {"mysql", "started"}]}]
    end

    test "returns true if the service is running", %{services: services} do
      assert Homebrew.running?(services, "mysql")
    end

    test "returns false if the service is not running", %{services: services} do
      refute Homebrew.running?(services, "postgresql")
    end

    test "returns false if the service is not listed", %{services: services} do
      refute Homebrew.running?(services, "glorp")
    end
  end

  describe "installed?" do
    setup do
      [packages: %Homebrew.Packages{installed: [{"postgresql", "1.1"}, {"mysql", "1.2"}]}]
    end

    test "returns true if the package is installed", %{packages: packages} do
      assert Homebrew.installed?(packages, "postgresql")
    end

    test "returns false if the package is not installed", %{packages: packages} do
      refute Homebrew.installed?(packages, "glorp")
    end

    test "returns false if the package is installed but the version does not match", %{packages: packages} do
      refute Homebrew.installed?(packages, "postgresql", version: "9.9")
    end
  end
end