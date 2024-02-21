defmodule TableCheck.Tables.TableQueryTest do
  use TableCheck.RepoCase, async: true

  alias TableCheck.Tables.TableQuery

  test "list_reserved_table_ids/1 when no tables at all" do
    assert [] ==
             TableQuery.list_reserved_table_ids(%{
               min_datetime: today_at!(~T[18:00:00]),
               max_datetime: today_at!(~T[22:00:00]),
               restaurant_id: 1
             })
  end

  test "list_reserved_table_ids/1 returns appropriate table ids" do
    restaurant = insert!(:restaurant_with_tables_and_guests)

    assert [] ==
             TableQuery.list_reserved_table_ids(%{
               min_datetime: today_at!(~T[18:00:00]),
               max_datetime: today_at!(~T[22:00:00]),
               restaurant_id: restaurant.id
             })

    {guest, table} = pick_table_for_reservation(restaurant)

    insert!(:reservation,
      guest_id: guest.id,
      table_id: table.id,
      start_at: today_at!(~T[18:00:00]),
      end_at: today_at!(~T[22:00:00])
    )

    # Test overlapping.
    for {min_datetime, max_datetime} <- overlapping_datetimes() do
      assert [reserved_table_id] =
               TableQuery.list_reserved_table_ids(%{
                 min_datetime: min_datetime,
                 max_datetime: max_datetime,
                 restaurant_id: restaurant.id
               })

      assert reserved_table_id == table.id
    end

    # Test not overlaping.

    assert [] =
             TableQuery.list_reserved_table_ids(%{
               min_datetime: today_at!(~T[17:00:00]),
               max_datetime: today_at!(~T[17:59:59]),
               restaurant_id: restaurant.id
             })
  end

  defp pick_table_for_reservation(%{guests: [guest], tables: [table]}) do
    {guest, table}
  end

  defp overlapping_datetimes do
    [
      {
        today_at!(~T[17:00:00]),
        today_at!(~T[18:00:00])
      },
      {
        today_at!(~T[22:00:00]),
        today_at!(~T[23:00:00])
      },
      {
        today_at!(~T[18:01:00]),
        today_at!(~T[21:59:00])
      }
    ]
  end

  defp today_at!(time) do
    NaiveDateTime.new!(Date.utc_today(), time)
  end
end
