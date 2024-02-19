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
        start_at: naive_tomorrow(),
        end_at: naive_tomorrow()
      )

    assert reservations = Reservations.list_reservations()

    assert first_reservation in reservations
    assert second_reservation in reservations

    assert [^second_reservation] =
             Reservations.list_reservations(%{date: NaiveDateTime.to_date(naive_tomorrow())})

    assert [^first_reservation] = Reservations.list_reservations(%{table_id: first_table.id})
  end

  defp naive_tomorrow do
    NaiveDateTime.utc_now()
    |> NaiveDateTime.add(1, :day)
    |> NaiveDateTime.truncate(:second)
  end
end
