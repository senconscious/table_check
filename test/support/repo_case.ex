defmodule TableCheck.RepoCase do
  use ExUnit.CaseTemplate

  using do
    quote do
      import TableCheck.RepoCase
      import TableCheck.Helpers.ChangesetHelper
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
