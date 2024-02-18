defmodule TableCheck.Tables do
  alias TableCheck.Tables.TableQuery

  defdelegate list_available_tables(filters), to: TableQuery, as: :list_available
end
