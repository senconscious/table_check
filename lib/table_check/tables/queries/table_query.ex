defmodule TableCheck.Tables.TableQuery do
  @moduledoc """
  Provides table queries
  """

  import Ecto.Query

  alias TableCheck.Restaurants.TableSchema

  alias TableCheck.Repo

  @type filters :: %{
          required(:restaurant_id) => integer(),
          required(:min_datetime) => NaiveDateTime.t(),
          required(:max_datetime) => NaiveDateTime.t()
        }

  @doc """
  Lists restaurant available tables based on provided time of day
  """
  @spec list_available(filters()) :: [TableSchema.t()]
  def list_available(filters) do
    filters
    |> list_reserved_table_ids()
    |> list_available(filters)
  end

  @doc false
  def list_available(reserved_table_ids, filters) do
    TableSchema
    |> by_restaurant(filters)
    |> by_available_id(reserved_table_ids)
    |> Repo.all()
  end

  @doc false
  def list_reserved_table_ids(filters) do
    TableSchema
    |> with_reservation(filters)
    |> by_restaurant(filters)
    |> distinct(true)
    |> select_ids()
    |> Repo.all()
  end

  defp with_reservation(query, %{min_datetime: min_datetime, max_datetime: max_datetime}) do
    join(query, :inner, [table], reservation in assoc(table, :reservations),
      on:
        fragment(
          "tsrange(?, ?, '[]') && tsrange(?, ?, '[]')",
          reservation.start_at,
          reservation.end_at,
          ^min_datetime,
          ^max_datetime
        ),
      as: :reservation
    )
  end

  defp by_restaurant(query, %{restaurant_id: restaurant_id}) do
    where(query, [table], table.restaurant_id == ^restaurant_id)
  end

  defp by_available_id(query, ids) do
    where(query, [table], table.id not in ^ids)
  end

  defp select_ids(query) do
    select(query, [table], table.id)
  end
end
