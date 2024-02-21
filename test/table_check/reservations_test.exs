defmodule TableCheck.ReservationsTest do
  use TableCheck.RepoCase, async: true

  alias TableCheck.Reservations

  test "list_reservations/1 properly fetches reservation" do
    assert [] == Reservations.list_reservations()

    %{tables: [first_table, second_table], guests: [guest]} =
      insert!(:restaurant_with_tables_and_guests, tables: [build(:table), build(:table)])

    first_reservation = insert!(:reservation, table_id: first_table.id, guest_id: guest.id)

    second_reservation =
      insert!(:reservation,
        table_id: second_table.id,
        guest_id: guest.id,
        start_at: tomorrow_timestamp(),
        end_at: tomorrow_timestamp()
      )

    assert reservations = Reservations.list_reservations()

    assert first_reservation in reservations
    assert second_reservation in reservations

    assert [^second_reservation] =
             Reservations.list_reservations(%{date: NaiveDateTime.to_date(tomorrow_timestamp())})

    assert [^first_reservation] = Reservations.list_reservations(%{table_id: first_table.id})
  end

  test "create_reservations/1 upserts existing guest" do
    %{tables: [table], guests: [guest]} = restaurant = insert!(:restaurant_with_tables_and_guests)

    assert {:ok, changes} =
             Reservations.create_reservations(%{
               table_id: table.id,
               start_at: today_at!(~T[18:00:00]),
               end_at: today_at!(~T[20:00:00]),
               guest: %{
                 name: "Updated name",
                 phone: guest.phone,
                 restaurant_id: restaurant.id
               }
             })

    assert changes.guest.id == guest.id
  end

  test "create_reservations/1 double book not possible" do
    %{tables: [table], guests: [guest]} = restaurant = insert!(:restaurant_with_tables_and_guests)

    insert!(:reservation,
      guest_id: guest.id,
      table_id: table.id,
      start_at: today_at!(~T[18:00:00]),
      end_at: today_at!(~T[22:00:00])
    )

    assert {:error, :reservation, changeset, _} =
             Reservations.create_reservations(%{
               start_at: today_at!(~T[17:00:00]),
               end_at: today_at!(~T[21:00:00]),
               table_id: table.id,
               guest: %{name: guest.name, phone: guest.phone, restaurant_id: restaurant.id}
             })

    assert errors_on(changeset).table_id == ["already reserved"]
  end

  defp tomorrow_timestamp do
    NaiveDateTime.utc_now()
    |> NaiveDateTime.add(1, :day)
    |> NaiveDateTime.truncate(:second)
  end

  defp today_at!(time) do
    NaiveDateTime.new!(Date.utc_today(), time)
  end
end
