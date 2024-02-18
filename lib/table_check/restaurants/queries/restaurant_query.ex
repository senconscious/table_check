defmodule TableCheck.Restaurants.RestaurantQuery do
  alias TableCheck.Restaurants.RestaurantSchema

  alias TableCheck.Repo

  def list_all do
    Repo.all(RestaurantSchema)
  end
end
