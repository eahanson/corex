defmodule Corex.FeatureCase do
  use ExUnit.CaseTemplate

  using do
    quote do
      use Wallaby.DSL

      alias Corex.Repo
      alias Corex.Test.Pages

      import Ecto
      import Ecto.Changeset
      import Ecto.Query

      import Corex.Test.Assertions
      import Corex.Test.FeatureHelpers
    end
  end

  setup tags do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(Corex.Repo)

    unless tags[:async] do
      Ecto.Adapters.SQL.Sandbox.mode(Corex.Repo, {:shared, self()})
    end

    metadata = Phoenix.Ecto.SQL.Sandbox.metadata_for(Corex.Repo, self())
    {:ok, session} = Wallaby.start_session(metadata: metadata)
    {:ok, session: session}
  end
end
