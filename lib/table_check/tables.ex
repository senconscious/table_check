defmodule TableCheck.Tables do
  @moduledoc """
  API interface to query restaurant tables availability
  """

  alias TableCheck.Tables.TableQuery

  defdelegate list_available_tables(filters), to: TableQuery, as: :list_available
end
