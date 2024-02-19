defmodule TableCheck.Reservations.GuestSchema do
  @moduledoc """
  Ecto Schema for Guest entity
  """

  use Ecto.Schema

  import Ecto.Changeset

  alias TableCheck.Restaurants.RestaurantSchema

  @type t :: %__MODULE__{
          id: integer(),
          name: String.t(),
          phone: String.t(),
          restaurant_id: integer(),
          inserted_at: NaiveDateTime.t(),
          updated_at: NaiveDateTime.t()
        }

  schema "guests" do
    field :name, :string
    field :phone, :string

    belongs_to :restaurant, RestaurantSchema

    timestamps()
  end

  def changeset(struct, attrs) do
    fields = fields()

    struct
    |> cast(attrs, fields)
    |> validate_required(fields)
    |> foreign_key_constraint(:restaurant_id)
    |> unique_constraint([:restaurant_id, :phone])
  end

  defp fields do
    (__schema__(:fields) -- __schema__(:primary_key)) -- [:inserted_at, :updated_at]
  end
end
