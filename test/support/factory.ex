defmodule TableCheck.Factory do
  @moduledoc """
  Provides factories for tests
  """

  alias TableCheck.Repo

  # Factories

  def build(:restaurant) do
    %TableCheck.Restaurants.RestaurantSchema{
      name: "some restaurant name"
    }
  end

  def build(:table) do
    %TableCheck.Restaurants.TableSchema{capacity: 1}
  end

  def build(:restaurant_with_tables) do
    %TableCheck.Restaurants.RestaurantSchema{
      name: "some restaurant name",
      tables: [
        build(:table)
      ]
    }
  end

  def build(:restaurant_with_tables_and_guests) do
    %TableCheck.Restaurants.RestaurantSchema{
      name: "some restaurant name",
      tables: [
        build(:table)
      ],
      guests: [
        build(:guest)
      ]
    }
  end

  def build(:guest) do
    %TableCheck.Reservations.GuestSchema{
      name: "Some guest name",
      phone: "14455544455"
    }
  end

  def build(:reservation) do
    %TableCheck.Reservations.ReservationSchema{
      start_at: naive_utc_now(),
      end_at: naive_utc_now()
    }
  end

  defp naive_utc_now do
    NaiveDateTime.truncate(NaiveDateTime.utc_now(), :second)
  end

  # Convenience API

  def build(factory_name, attributes) do
    factory_name
    |> build()
    |> struct!(attributes)
  end

  def insert!(factory_name, attributes \\ []) do
    factory_name
    |> build(attributes)
    |> Repo.insert!()
  end
end
