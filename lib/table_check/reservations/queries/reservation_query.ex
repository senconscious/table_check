defmodule TableCheck.Reservations.ReservationQuery do
  @moduledoc """
  Provides listing reservations
  """

  import Ecto.Query

  alias TableCheck.Reservations.ReservationSchema

  alias TableCheck.Repo

  @type filters :: %{
          optional(:table_id) => integer(),
          optional(:date) => Date.t()
        }

  @doc """
  List reservations in system.

  ## Filters

  - table_id - identifier of table for which list reservations. If not provided than lists
        all reservations in system
  - date - date when reservation started
  """
  @spec list_all(filters()) :: [ReservationSchema.t()]
  def list_all(filters \\ %{})

  def list_all(filters) do
    ReservationSchema
    |> by_table(filters)
    |> by_date(filters)
    |> Repo.all()
  end

  defp by_table(query, %{table_id: table_id}) do
    where(query, table_id: ^table_id)
  end

  defp by_table(query, _), do: query

  defp by_date(query, %{date: date}) do
    where(query, [reservation], fragment("?::date", reservation.start_at) == ^date)
  end

  defp by_date(query, _), do: query
end
