defmodule TableCheck.Restaurants.RestaurantQuery do
  @moduledoc """
  Provides restaurant queries
  """

  alias TableCheck.Restaurants.RestaurantSchema

  alias TableCheck.Repo

  @spec list_all() :: [RestaurantSchema.t()]
  def list_all do
    Repo.all(RestaurantSchema)
  end
end
