defmodule TableCheck.Tables do
  @moduledoc """
  API interface to query restaurant tables availability

  ## Query restaurant availability

  You need specify `restaurant_id`, and a period for availability check via
  `min_datetime` and `max_datetime` keys.
  Availability check range borders are inclusive.
  So if there is a reservation for table at `2024-02-19 17:00:00` and your
  `max_datetime` is `~N[2024-02-19 17:00:00]` that this table won't be available.

  ```elixir
  iex> TableCheck.Tables.list_available_tables(%{
        restaurant_id: 1,
        min_datetime: ~N[2024-02-19 17:00:00],
        max_datetime: ~N[2024-02-19 19:00:00]
    })
  ```
  """

  alias TableCheck.Tables.TableQuery

  defdelegate list_available_tables(filters), to: TableQuery, as: :list_available
end
