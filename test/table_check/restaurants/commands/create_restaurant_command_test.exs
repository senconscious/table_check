defmodule TableCheck.Restaurants.CreateRestaurantCommandTest do
  use TableCheck.RepoCase, async: true

  alias TableCheck.Restaurants.CreateRestaurantCommand

  test "build_new_restaurant/1 when no name provided" do
    errors = errors_on(CreateRestaurantCommand.build_new_restaurant(%{}))
    assert errors.name == ["can't be blank"]
  end

  test "build_new_restaurant/1 when valid attrs provided" do
    errors = errors_on(CreateRestaurantCommand.build_new_restaurant(%{name: "test restaurant"}))
    assert errors == %{}
  end
end
