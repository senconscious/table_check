defmodule TableCheck.Reservations do
  @moduledoc """
  API interface to manage restaurant table reservations

  ## Reserve a table

  Assuming we previously created restaurant and table:

  ```elixir
  iex> TableCheck.Reservations.create_reservations(%{
            start_at: ~N[2024-02-19 18:00:00],
            end_at: ~N[2024-02-19 22:00:00],
            table_id: 1,
            guest: %{
                name: "my best guest",
                phone: "some_magic_phone",
                restaurant_id: 1
            }
    })
  ```

  If the same guest try to reserve a table in the same restaurant in the future
  that it'll be upserted.

  ## Listing reservations

  Your can check all reservations in the sysmet by calling:

  ```elixir
  iex> TableCheck.Reservations.list_reservations()
  ```

  Also you can check reservations by specific table:

  ```elixir
  iex> TableCheck.Reservations.list_reservations(%{table_id: 1})
  ```

  And by specific date as well:

  ```elixir
  iex> TableCheck.Reservations.list_reservations(%{table_id: 1, date: ~D[2024-02-20]})
  ```
  """

  alias TableCheck.Reservations.ReservationQuery

  alias TableCheck.Reservations.CreateReservationCommand

  defdelegate create_reservations(attrs), to: CreateReservationCommand, as: :execute

  defdelegate list_reservations, to: ReservationQuery, as: :list_all

  defdelegate list_reservations(filters), to: ReservationQuery, as: :list_all
end
