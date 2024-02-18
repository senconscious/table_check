defmodule TableCheck.Reservations.ReservationSchema do
  use Ecto.Schema

  import Ecto.Changeset

  alias TableCheck.Restaurants.TableSchema
  alias TableCheck.Reservations.GuestSchema

  schema "reservations" do
    field :status, Ecto.Enum, values: [:pending, :paid, :completed, :cancelled], default: :pending
    field :date, :date
    field :start_at, :time
    field :end_at, :time

    belongs_to :table, TableSchema
    belongs_to :guest, GuestSchema

    timestamps()
  end

  def changeset(struct, attrs) do
    fields = fields()

    struct
    |> cast(attrs, fields)
    |> validate_required(fields)
    |> foreign_key_constraint(:table_id)
    |> foreign_key_constraint(:guest_id)
  end

  defp fields do
    (__schema__(:fields) -- __schema__(:primary_key)) -- [:inserted_at, :updated_at]
  end
end
