defmodule TableCheck.Restaurants.CreateRestaurantCommand do
  @moduledoc """
  Provides business command to add new restaurant in system
  """

  alias TableCheck.Restaurants.RestaurantSchema

  alias TableCheck.Repo

  @type attrs :: %{
    name: String.t()
  }

  @spec execute(attrs()) :: {:ok, RestaurantSchema.t()} | {:error, Ecto.Changeset.t()}
  def execute(attrs) do
    attrs
    |> build_new_restaurant()
    |> Repo.insert()
  end

  @doc false
  def build_new_restaurant(attrs) do
    RestaurantSchema.changeset(%RestaurantSchema{}, attrs)
  end
end
