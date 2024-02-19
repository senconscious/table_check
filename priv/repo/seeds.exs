defmodule TableCheck.Seeds do
  alias TableCheck.Restaurants
  alias TableCheck.Reservations

  alias TableCheck.Repo

  @restaurants "priv/restaurants.json"

  @doc """
  Seeds restaurants from file, creates tables for each restaurant and
  makes some reservations for tomorrow for some tables
  """
  def run do
    @restaurants
    |> read_restaurants!()
    |> seed_restaurants()
  end

  defp read_restaurants!(path) do
    path
    |> File.read!()
    |> Jason.decode!()
  end

  defp seed_restaurants(names) do
    Repo.transaction(fn ->
      names
      |> Stream.map(&seed_restaurant/1)
      |> Stream.map(&seed_tables/1)
      |> Enum.each(&seed_reservations/1)
    end)
  end

  defp seed_restaurant(name) do
    {:ok, restaurant} = Restaurants.create_restaurant(%{name: name})
    restaurant
  end

  defp seed_tables(restaurant) do
    {restaurant, create_restaurant_tables(restaurant.id)}
  end

  defp create_restaurant_tables(restaurant_id) do
    Enum.reduce(1..10, [], fn _, tables ->
      {:ok, table} =
        Restaurants.create_table(%{capacity: Enum.random([1, 2, 3]), restaurant_id: restaurant_id})

      [table | tables]
    end)
  end

  defp seed_reservations({restaurant, tables}) do
    Enum.each(tables, fn table ->
      tomorrow = tomorrow()
      after_10_days = NaiveDateTime.add(tomorrow, 10, :day)

      tomorrow
      |> reservation_time_range(after_10_days)
      |> Enum.map(fn {start_at, end_at} ->
        Reservations.create_reservations(%{
          start_at: start_at,
          end_at: end_at,
          table_id: table.id,
          guest:
            Enum.random([
              %{name: "First guest", phone: "14455544455", restaurant_id: restaurant.id},
              %{name: "Second guest guest", phone: "14455544456", restaurant_id: restaurant.id}
            ])
        })
      end)
    end)
  end

  defp tomorrow(date \\ NaiveDateTime.utc_now()) do
    NaiveDateTime.add(date, 24, :hour)
  end

  # returns time ranges for reservation in provided range
  # each reservation takes 2 hours
  # next reservation start after 1 hour break
  defp reservation_time_range(min_datetime, max_datetime) do
    Stream.resource(
      fn -> %{current_datetime: min_datetime, max_datetime: max_datetime} end,
      fn acc ->
        new_current_datetime = NaiveDateTime.add(acc.current_datetime, 2, :hour)

        if NaiveDateTime.compare(new_current_datetime, acc.max_datetime) == :lt do
          {[{acc.current_datetime, new_current_datetime}],
           Map.put(acc, :current_datetime, NaiveDateTime.add(new_current_datetime, 1, :hour))}
        else
          {:halt, acc}
        end
      end,
      fn _ -> :ok end
    )
  end
end

TableCheck.Seeds.run()
