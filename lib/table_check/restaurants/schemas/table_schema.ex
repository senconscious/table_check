defmodule TableCheck.Restaurants.TableSchema do
  use Ecto.Schema

  import Ecto.Changeset

  alias TableCheck.Restaurants.RestaurantSchema

  schema "tables" do
    field :capacity, :integer

    belongs_to :restaurant, RestaurantSchema

    timestamps()
  end

  def changeset(struct, attrs) do
    fields = fields()

    struct
    |> cast(attrs, fields)
    |> validate_required(fields)
    |> validate_number(:capacity, greater_than: 0)
    |> foreign_key_constraint(:restaurant_id)
  end

  def fields do
    (__schema__(:fields) -- __schema__(:primary_key)) -- [:inserted_at, :updated_at]
  end
end
