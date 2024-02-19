defmodule TableCheck.Restaurants do
  @moduledoc """
  API interface to manage restaurant and it's tables

  ## Listing restaurants

  Simply returns all restaurants in the system

  ```elixir
  iex> restaurants = TableCheck.Restaurants.list_restaurants()
  ```

  ## Creating restaurant

  ```elixir
  iex> {:ok, restaurant} = TableCheck.Restaurants.create_restaurant(%{
    name: "My best restaurant"
  })
  ```

  ## Creating table for restaurant

  ```elixir
  iex> {:ok, table} = TableCheck.Restaurants.create_table(%{
    # table for 1 person
    capacity: 1,
    # id of previously created restaurant
    restaurant_id: 1
  })
  ```

  ## Listing restaurant tables

  ```elixir
  iex> TableCheck.Restaurants.list_tables(1) # pass id of previously created restaurant
  ```

  """

  alias TableCheck.Restaurants.RestaurantQuery
  alias TableCheck.Restaurants.TableQuery

  alias TableCheck.Restaurants.CreateRestaurantCommand
  alias TableCheck.Restaurants.CreateTableCommand

  defdelegate list_restaurants, to: RestaurantQuery, as: :list_all

  defdelegate create_restaurant(attrs), to: CreateRestaurantCommand, as: :execute

  defdelegate create_table(attrs), to: CreateTableCommand, as: :execute

  defdelegate list_tables(restaurant_id), to: TableQuery, as: :list_all
end
