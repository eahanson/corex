defmodule Corex.CLI.CircleCITest do
  use Corex.SimpleCase, async: true

  alias Corex.CLI.CircleCI

  describe "parse" do
    test "returns build status" do
      parsed = File.read!("test/support/fixtures/circle_ci_response.json") |> CircleCI.parse()
      assert parsed == true
    end
  end
end