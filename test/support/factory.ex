defmodule TableCheck.Factory do
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

  def build(:guest) do
    %TableCheck.Reservations.GuestSchema{
      name: "Some guest name",
      phone: "14455544455"
    }
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
