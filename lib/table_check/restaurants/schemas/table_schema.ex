defmodule TableCheck.Restaurants.TableSchema do
  @moduledoc """
  Ecto Schema for Table entity
  """

  use Ecto.Schema

  import Ecto.Changeset

  alias TableCheck.Reservations.ReservationSchema
  alias TableCheck.Restaurants.RestaurantSchema

  @type t :: %__MODULE__{
          id: integer(),
          capacity: integer(),
          restaurant_id: integer(),
          inserted_at: NaiveDateTime.t(),
          updated_at: NaiveDateTime.t()
        }

  schema "tables" do
    field :capacity, :integer

    belongs_to :restaurant, RestaurantSchema

    has_many :reservations, ReservationSchema, foreign_key: :table_id

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
