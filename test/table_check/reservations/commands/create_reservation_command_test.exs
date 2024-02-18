defmodule TableCheck.Reservations.CreateReservationCommandTest do
  use TableCheck.RepoCase, async: true

  alias TableCheck.Reservations.CreateReservationCommand

  test "build_guest/1 when empty attrs provided" do
    errors =
      %{}
      |> CreateReservationCommand.build_guest()
      |> errors_on()

    assert errors.name == ["can't be blank"]
    assert errors.phone == ["can't be blank"]
    assert errors.restaurant_id == ["can't be blank"]
  end

  test "build_reservation/2 when empty attrs provided" do
    errors =
      %{guest: %{id: 1}}
      |> CreateReservationCommand.build_reservation(%{})
      |> errors_on()

    assert errors.date == ["can't be blank"]
    assert errors.end_at == ["can't be blank"]
    assert errors.start_at == ["can't be blank"]
    assert errors.table_id == ["can't be blank"]
  end

  test "execute/1 upserts existing guest" do
    restaurant = insert!(:restaurant)
    table = insert!(:table, restaurant_id: restaurant.id)
    guest = insert!(:guest, restaurant_id: restaurant.id)

    assert {:ok, changes} =
             CreateReservationCommand.execute(%{
               table_id: table.id,
               date: Date.utc_today(),
               start_at: ~T[18:00:00],
               end_at: ~T[20:00:00],
               guest: %{
                 name: "Updated name",
                 phone: guest.phone,
                 restaurant_id: restaurant.id
               }
             })

    assert changes.guest.id == guest.id
  end
end
