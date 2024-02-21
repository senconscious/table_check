defmodule TableCheck.Restaurants.CreateRestaurantCommandTest do
  use TableCheck.RepoCase, async: true

  alias TableCheck.Restaurants.CreateRestaurantCommand

  test "build_new_restaurant/1 when no name provided" do
    errors =
      %{}
      |> CreateRestaurantCommand.build_new_restaurant()
      |> errors_on()

    assert errors.name == ["can't be blank"]
  end

  test "build_new_restaurant/1 when valid attrs provided" do
    errors =
      %{name: "test restaurant"}
      |> CreateRestaurantCommand.build_new_restaurant()
      |> errors_on()

    assert errors == %{}
  end
end
