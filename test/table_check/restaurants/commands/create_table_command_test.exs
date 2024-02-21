defmodule TableCheck.Restaurants.CreateTableCommandTest do
  use TableCheck.RepoCase, async: true

  alias TableCheck.Restaurants.CreateTableCommand

  test "build_new_table/1 empty attrs provided" do
    errors =
      %{}
      |> CreateTableCommand.build_new_table()
      |> errors_on()

    assert errors.capacity == ["can't be blank"]
    assert errors.restaurant_id == ["can't be blank"]
  end

  test "build_new_table/1 non positive capacity provided" do
    errors =
      %{capacity: 0, restaurant_id: 1}
      |> CreateTableCommand.build_new_table()
      |> errors_on()

    assert errors.capacity == ["must be greater than 0"]
  end

  test "build_new_table/1 when valid attrs provided" do
    errors =
      %{capacity: 1, restaurant_id: 1}
      |> CreateTableCommand.build_new_table()
      |> errors_on()

    assert errors == %{}
  end

  test "execute/1 when not existing restaurant provided" do
    assert {:error, changeset} = CreateTableCommand.execute(%{capacity: 1, restaurant_id: 100})
    errors = errors_on(changeset)

    assert errors.restaurant_id == ["does not exist"]
  end
end
