defmodule TableCheck.Restaurants.CreateRestaurantCommand do
  alias TableCheck.Restaurants.RestaurantSchema

  alias TableCheck.Repo

  def execute(attrs) do
    attrs
    |> build_new_restaurant()
    |> Repo.insert()
  end

  def build_new_restaurant(attrs) do
    RestaurantSchema.changeset(%RestaurantSchema{}, attrs)
  end
end
