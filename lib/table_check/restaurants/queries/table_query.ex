defmodule TableCheck.Restaurants.TableQuery do
  @moduledoc """
  Provides table queries
  """

  import Ecto.Query, only: [where: 2]

  alias TableCheck.Restaurants.TableSchema

  alias TableCheck.Repo

  @doc """
  Returns restaurant all tables
  """
  @spec list_all(integer()) :: [TableSchema.t()]
  def list_all(restaurant_id) do
    TableSchema
    |> by_restaurant(restaurant_id)
    |> Repo.all()
  end

  defp by_restaurant(query, restaurant_id) do
    where(query, restaurant_id: ^restaurant_id)
  end
end
