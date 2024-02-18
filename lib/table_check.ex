defmodule TableCheck do
  @moduledoc """
  Documentation for `TableCheck`.
  """

  @type params :: %{
          required(:restaurant_id) => integer(),
          required(:date) => Date.t(),
          required(:min_time) => Time.t(),
          required(:max_time) => Time.t()
        }

  @type table :: %{
          id: integer(),
          capacity: :one | :two | :three | :four
        }

  @doc """
  Returns list of non-reserved tables in a period of time.
  """
  @spec list_available_tables(params()) :: [table()]
  def list_available_tables(_params) do
    []
  end
end
