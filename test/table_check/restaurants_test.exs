defmodule TableCheck.RestaurantsTest do
  use TableCheck.RepoCase, async: true

  alias TableCheck.Restaurants

  test "list_restaurants properly fetches restaurants" do
    assert [] = Restaurants.list_restaurants()

    restaurant = insert!(:restaurant)

    assert [^restaurant] = Restaurants.list_restaurants()
  end

  test "list_tables/1 properly fetches restaurant table" do
    %{tables: [table]} = restaurant = insert!(:restaurant_with_tables)

    assert [] = Restaurants.list_tables(restaurant.id + 1)

    assert [restaurant_table] = Restaurants.list_tables(restaurant.id)

    assert restaurant_table.id == table.id
  end
end
