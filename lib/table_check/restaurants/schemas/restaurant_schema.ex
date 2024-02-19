defmodule TableCheck.Restaurants.RestaurantSchema do
  @moduledoc """
  Ecto Schema for Restaurant Entity
  """

  use Ecto.Schema

  import Ecto.Changeset

  alias TableCheck.Restaurants.TableSchema

  @type t :: %__MODULE__{
    id: integer(),
    name: String.t(),
    inserted_at: NaiveDateTime.t(),
    updated_at: NaiveDateTime.t()
  }

  schema "restaurants" do
    field :name, :string

    has_many :tables, TableSchema, foreign_key: :restaurant_id

    timestamps()
  end

  def changeset(struct, attrs) do
    fields = fields()

    struct
    |> cast(attrs, fields)
    |> validate_required(fields)
  end

  defp fields do
    (__schema__(:fields) -- __schema__(:primary_key)) -- [:inserted_at, :updated_at]
  end
end
