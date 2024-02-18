defmodule TableCheck.Restaurants do
  @moduledoc """
  API interface for restaurants
  """

  alias TableCheck.Restaurants.RestaurantQuery

  alias TableCheck.Restaurants.CreateRestaurantCommand
  alias TableCheck.Restaurants.CreateTableCommand

  defdelegate list_restaurants, to: RestaurantQuery, as: :list_all

  defdelegate create_restaurant(attrs), to: CreateRestaurantCommand, as: :execute

  defdelegate create_table(attrs), to: CreateTableCommand, as: :execute
end
