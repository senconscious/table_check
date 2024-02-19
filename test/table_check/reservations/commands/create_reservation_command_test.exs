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
               start_at: new_timestamp!(~T[18:00:00]),
               end_at: new_timestamp!(~T[20:00:00]),
               guest: %{
                 name: "Updated name",
                 phone: guest.phone,
                 restaurant_id: restaurant.id
               }
             })

    assert changes.guest.id == guest.id
  end

  test "execute/1 double book not possible" do
    restaurant = insert!(:restaurant)
    table = insert!(:table, restaurant_id: restaurant.id)
    guest = insert!(:guest, restaurant_id: restaurant.id)

    insert!(:reservation,
      guest_id: guest.id,
      table_id: table.id,
      start_at: new_timestamp!(~T[18:00:00]),
      end_at: new_timestamp!(~T[22:00:00])
    )

    assert {:error, :reservation, changeset, _} =
             CreateReservationCommand.execute(%{
               start_at: new_timestamp!(~T[17:00:00]),
               end_at: new_timestamp!(~T[21:00:00]),
               table_id: table.id,
               guest: %{name: guest.name, phone: guest.phone, restaurant_id: restaurant.id}
             })

    assert errors_on(changeset).table_id == ["already reserved"]
  end

  defp new_timestamp!(time) do
    NaiveDateTime.new!(Date.utc_today(), time)
  end
end
