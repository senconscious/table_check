defmodule TableCheck.Tables.TableQueryTest do
  use TableCheck.RepoCase, async: true

  alias TableCheck.Tables.TableQuery

  test "list_reserved_table_ids/1 when no tables at all" do
    assert [] ==
             TableQuery.list_reserved_table_ids(%{
               min_datetime: new_timestamp!(~T[18:00:00]),
               max_datetime: new_timestamp!(~T[22:00:00]),
               restaurant_id: 1
             })
  end

  test "list_reserved_table_ids/1 returns appropriate table ids" do
    restaurant = insert!(:restaurant)
    table = insert!(:table, restaurant_id: restaurant.id)

    assert [] ==
             TableQuery.list_reserved_table_ids(%{
               min_datetime: new_timestamp!(~T[18:00:00]),
               max_datetime: new_timestamp!(~T[22:00:00]),
               restaurant_id: restaurant.id
             })

    guest = insert!(:guest, restaurant_id: restaurant.id)

    insert!(:reservation,
      guest_id: guest.id,
      table_id: table.id,
      start_at: new_timestamp!(~T[18:00:00]),
      end_at: new_timestamp!(~T[22:00:00])
    )

    # test overlapping
    for {min_datetime, max_datetime} <- [
          {
            new_timestamp!(~T[17:00:00]),
            new_timestamp!(~T[18:00:00])
          },
          {
            new_timestamp!(~T[22:00:00]),
            new_timestamp!(~T[23:00:00])
          },
          {
            new_timestamp!(~T[18:01:00]),
            new_timestamp!(~T[21:59:00])
          }
        ] do
      assert [reserved_table_id] =
               TableQuery.list_reserved_table_ids(%{
                 min_datetime: min_datetime,
                 max_datetime: max_datetime,
                 restaurant_id: restaurant.id
               })

      assert reserved_table_id == table.id
    end

    # test not overlaping

    assert [] =
             TableQuery.list_reserved_table_ids(%{
               min_datetime: new_timestamp!(~T[17:00:00]),
               max_datetime: new_timestamp!(~T[17:59:59]),
               restaurant_id: restaurant.id
             })
  end

  test "list_available/1" do
    restaurant = insert!(:restaurant)
    available_table = insert!(:table, restaurant_id: restaurant.id)
    reserved_table = insert!(:table, restaurant_id: restaurant.id)
    guest = insert!(:guest, restaurant_id: restaurant.id)

    insert!(:reservation,
      guest_id: guest.id,
      table_id: reserved_table.id,
      start_at: new_timestamp!(~T[18:00:00]),
      end_at: new_timestamp!(~T[22:00:00])
    )

    assert [actual_available_table] =
             TableQuery.list_available(%{
               min_datetime: new_timestamp!(~T[18:00:00]),
               max_datetime: new_timestamp!(~T[22:00:00]),
               restaurant_id: restaurant.id
             })

    assert actual_available_table.id == available_table.id
  end

  defp new_timestamp!(time) do
    NaiveDateTime.new!(Date.utc_today(), time)
  end
end