defmodule TableCheck.Reservations.CreateReservationCommand do
  @moduledoc """
  Provides business command to create reservation in system.
  """

  alias TableCheck.Reservations.GuestSchema
  alias TableCheck.Reservations.ReservationSchema

  alias Ecto.Multi

  alias TableCheck.Repo

  @type attrs :: %{
          start_at: NaiveDateTime.t(),
          end_at: NaiveDateTime.t(),
          table_id: integer(),
          guest: %{
            name: String.t(),
            phone: String.t(),
            restaurant_id: integer()
          }
        }

  @type reservation_with_guest :: %{
    guest: GuestSchema.t(),
    reservation: ReservationSchema.t()
  }

  @spec execute(attrs()) :: {:ok, reservation_with_guest()} | {:error, Ecto.Multi.name(), Ecto.Changeset.t(), map()}
  def execute(attrs) do
    Multi.new()
    |> Multi.insert(:guest, build_guest(attrs.guest),
      on_conflict: {:replace_all_except, [:id, :restaurant_id, :phone]},
      conflict_target: [:restaurant_id, :phone]
    )
    |> Multi.insert(:reservation, &build_reservation(&1, attrs))
    |> Repo.transaction()
  end

  @doc false
  def build_guest(attrs) do
    GuestSchema.changeset(%GuestSchema{}, attrs)
  end

  @doc false
  def build_reservation(%{guest: %{id: guest_id}}, attrs) do
    ReservationSchema.changeset(%ReservationSchema{}, Map.put(attrs, :guest_id, guest_id))
  end
end
