defmodule TableCheck.Restaurants.RestaurantSchema do
  @moduledoc """
  Ecto Schema for Restaurant Entity
  """

  use Ecto.Schema

  import Ecto.Changeset

  schema "restaurants" do
    field :name, :string

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
