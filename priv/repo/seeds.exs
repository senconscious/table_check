defmodule TableCheck.Seeds do
  alias TableCheck.Restaurants
  alias TableCheck.Reservations

  def run do
    {:ok, restaurant} = Restaurants.create_restaurant(%{name: "Gucci Osteria Tokyo"})

    {:ok, first_table} = Restaurants.create_table(%{capacity: 1, restaurant_id: restaurant.id})

    {:ok, second_table} = Restaurants.create_table(%{capacity: 2, restaurant_id: restaurant.id})

    {:ok, _} = Restaurants.create_table(%{capacity: 3, restaurant_id: restaurant.id})

    {:ok, _} = Reservations.create_reservations(%{
      start_at: tomorrow(),
      end_at: NaiveDateTime.add(tomorrow(), 2, :hour),
      table_id: first_table.id,
      guest: %{name: "First guest", phone: "14455544455", restaurant_id: restaurant.id}
    })

    {:ok, _} = Reservations.create_reservations(%{
      start_at: tomorrow(),
      end_at: NaiveDateTime.add(tomorrow(), 3, :hour),
      table_id: second_table.id,
      guest: %{name: "Second guest guest", phone: "14455544456", restaurant_id: restaurant.id}
    })
  end

  defp tomorrow do
    NaiveDateTime.utc_now()
    |> NaiveDateTime.add(24, :hour)
  end
end

TableCheck.Seeds.run()
