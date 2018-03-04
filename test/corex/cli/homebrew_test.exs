defmodule Corex.CLI.HomebrewTest do
  use Corex.SimpleCase, async: true

  alias Corex.CLI.Homebrew

  describe "decode_json" do
    test "when there is some stderr output" do
      json = "/usr/local/Homebrew/Library/Homebrew/brew.rb (Formulary::FormulaLoader): loading /usr/local/Homebrew/Library/Taps/homebrew/homebrew-core/Formula/elixir.rb\n[{\"name\":\"elixir\",\"full_name\":\"elixir\",\"desc\":\"Functional metaprogramming aware language built on Erlang VM\",\"homepage\":\"https://elixir-lang.org/\",\"oldname\":null,\"aliases\":[],\"versions\":{\"stable\":\"1.6.0\",\"bottle\":true,\"devel\":null,\"head\":\"HEAD\"},\"revision\":0,\"version_scheme\":0,\"installed\":[{\"version\":\"1.5.2\",\"used_options\":[],\"built_as_bottle\":true,\"poured_from_bottle\":true,\"runtime_dependencies\":[{\"full_name\":\"erlang\",\"version\":\"20.1\"}],\"installed_as_dependency\":false,\"installed_on_request\":true}],\"linked_keg\":\"1.5.2\",\"pinned\":false,\"outdated\":true,\"keg_only\":false,\"dependencies\":[\"erlang\"],\"recommended_dependencies\":[],\"optional_dependencies\":[],\"build_dependencies\":[],\"conflicts_with\":[],\"caveats\":null,\"requirements\":[],\"options\":[],\"bottle\":{\"stable\":{\"rebuild\":0,\"cellar\":\"/usr/local/Cellar\",\"prefix\":\"/usr/local\",\"root_url\":\"https://homebrew.bintray.com/bottles\",\"files\":{\"high_sierra\":{\"url\":\"https://homebrew.bintray.com/bottles/elixir-1.6.0.high_sierra.bottle.tar.gz\",\"sha256\":\"2674d6347ddad33a77771264e49f91e3dd7b49b64ea8bac5cde11476a352c7e0\"},\"sierra\":{\"url\":\"https://homebrew.bintray.com/bottles/elixir-1.6.0.sierra.bottle.tar.gz\",\"sha256\":\"fcb95bb5b7415303c272da91e4a369233c4cb466f6af16eb1e6a5396ee3e7111\"},\"el_capitan\":{\"url\":\"https://homebrew.bintray.com/bottles/elixir-1.6.0.el_capitan.bottle.tar.gz\",\"sha256\":\"8d3380a735359b041d72fa5a2f2d6125b059601a4a50bdb7ff8b73256eb601d2\"}}}}}]\n"
      decoded = Homebrew.decode_json(json)

      assert decoded |> is_list()
      assert decoded |> hd() |> is_map()
    end
  end
end