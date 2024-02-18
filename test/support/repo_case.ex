defmodule TableCheck.RepoCase do
  use ExUnit.CaseTemplate

  using do
    quote do
      import TableCheck.RepoCase
      import TableCheck.Helpers.ChangesetHelper
      import TableCheck.Factory, only: [build: 2, insert!: 1, insert!: 2]
    end
  end

  setup tags do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(TableCheck.Repo)

    unless tags[:async] do
      Ecto.Adapters.SQL.Sandbox.mode(TableCheck.Repo, {:shared, self()})
    end

    :ok
  end
end
