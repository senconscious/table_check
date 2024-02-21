defmodule TableCheck.Reservations.ReservationSchema do
  @moduledoc """
  Ecto Schema for Reservation entity
  """
  use Ecto.Schema

  import Ecto.Changeset

  alias TableCheck.Reservations.GuestSchema
  alias TableCheck.Restaurants.TableSchema

  @type t :: %__MODULE__{
          id: integer(),
          start_at: NaiveDateTime.t(),
          end_at: NaiveDateTime.t(),
          table_id: integer(),
          guest_id: integer(),
          inserted_at: NaiveDateTime.t(),
          updated_at: NaiveDateTime.t()
        }

  schema "reservations" do
    field :start_at, :naive_datetime
    field :end_at, :naive_datetime

    belongs_to :table, TableSchema
    belongs_to :guest, GuestSchema

    timestamps()
  end

  def changeset(struct, attrs) do
    fields = fields()

    struct
    |> cast(attrs, fields)
    |> validate_required(fields)
    |> validate_time_order()
    |> foreign_key_constraint(:table_id)
    |> foreign_key_constraint(:guest_id)
    |> exclusion_constraint(:table_id, name: :time_not_overlap, message: "already reserved")
  end

  defp fields do
    (__schema__(:fields) -- __schema__(:primary_key)) -- [:inserted_at, :updated_at]
  end

  defp validate_time_order(%{valid?: true} = changeset) do
    start_at = get_field(changeset, :start_at)
    end_at = get_field(changeset, :end_at)

    case NaiveDateTime.compare(start_at, end_at) do
      :gt ->
        add_error(changeset, :end_at, "must be latter that start_at")

      :eq ->
        add_error(changeset, :end_at, "can't be the same as start_at")

      :lt ->
        changeset
    end
  end

  defp validate_time_order(changeset), do: changeset
end
