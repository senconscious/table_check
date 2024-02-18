defmodule TableCheck.Reservations.CreateReservationCommand do
  alias TableCheck.Reservations.GuestSchema
  alias TableCheck.Reservations.ReservationSchema

  alias Ecto.Multi

  alias TableCheck.Repo

  def execute(attrs) do
    Multi.new()
    |> Multi.insert(:guest, build_guest(attrs.guest),
      on_conflict: {:replace_all_except, [:id, :restaurant_id, :phone]},
      conflict_target: [:restaurant_id, :phone]
    )
    |> Multi.insert(:reservation, &build_reservation(&1, attrs))
    |> Repo.transaction()
  end

  def build_guest(attrs) do
    GuestSchema.changeset(%GuestSchema{}, attrs)
  end

  def build_reservation(%{guest: %{id: guest_id}}, attrs) do
    ReservationSchema.changeset(%ReservationSchema{}, Map.put(attrs, :guest_id, guest_id))
  end
end
