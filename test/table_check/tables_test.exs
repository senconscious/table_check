defmodule TableCheck.TablesTest do
  use TableCheck.RepoCase, async: true

  alias TableCheck.Tables

  test "list_available_tables/1 return appropriate tables" do
    %{guests: [guest], tables: [available_table, reserved_table]} =
      restaurant =
      insert!(:restaurant_with_tables_and_guests, tables: [build(:table), build(:table)])

    insert!(:reservation,
      guest_id: guest.id,
      table_id: reserved_table.id,
      start_at: today_at!(~T[18:00:00]),
      end_at: today_at!(~T[22:00:00])
    )

    assert [actual_available_table] =
             Tables.list_available_tables(%{
               min_datetime: today_at!(~T[18:00:00]),
               max_datetime: today_at!(~T[22:00:00]),
               restaurant_id: restaurant.id
             })

    assert actual_available_table.id == available_table.id
  end

  defp today_at!(time) do
    NaiveDateTime.new!(Date.utc_today(), time)
  end
end
