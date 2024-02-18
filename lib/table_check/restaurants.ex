defmodule TableCheck.Restaurants do
  @moduledoc """
  API interface for restaurants
  """

  alias TableCheck.Restaurants.RestaurantQuery
  alias TableCheck.Restaurants.CreateRestaurantCommand

  defdelegate list_restaurants, to: RestaurantQuery, as: :list_all

  defdelegate create_restaurant(attrs), to: CreateRestaurantCommand, as: :execute
end
