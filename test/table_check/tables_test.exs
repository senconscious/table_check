defmodule TableCheck.TablesTest do
  use TableCheck.RepoCase, async: true

  alias TableCheck.Tables

  test "list_available_tables/1" do
    restaurant = create_restaurant_with_tables_and_guests()
    {guest, table_to_reserve, available_table} = pick_table_for_reservation(restaurant)
    reserve_table(guest, table_to_reserve, today_at!(~T[18:00:00]), today_at!(~T[22:00:00]))

    assert [actual_available_table] =
             Tables.list_available_tables(%{
               min_datetime: today_at!(~T[17:00:00]),
               max_datetime: today_at!(~T[21:00:00]),
               restaurant_id: restaurant.id
             })

    assert actual_available_table.id == available_table.id
  end

  defp create_restaurant_with_tables_and_guests do
    insert!(:restaurant_with_tables_and_guests, tables: [build(:table), build(:table)])
  end

  defp pick_table_for_reservation(%{guests: [guest], tables: [table_to_reserve, available_table]}) do
    {guest, table_to_reserve, available_table}
  end

  defp reserve_table(guest, table, start_at, end_at) do
    insert!(:reservation,
      guest_id: guest.id,
      table_id: table.id,
      start_at: start_at,
      end_at: end_at
    )
  end

  defp today_at!(time) do
    NaiveDateTime.new!(Date.utc_today(), time)
  end
end
