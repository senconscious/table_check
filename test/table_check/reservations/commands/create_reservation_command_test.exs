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

  test "build_reservation/2 when reservation start is latter than end" do
    start_at = NaiveDateTime.utc_now()
    end_at = NaiveDateTime.add(start_at, -1, :hour)

    errors =
      %{guest: %{id: 1}}
      |> CreateReservationCommand.build_reservation(%{
        table_id: 1,
        start_at: start_at,
        end_at: end_at
      })
      |> errors_on()

    assert errors.end_at == ["must be latter that start_at"]
  end

  test "build_reservation/2 when reservation starts and ends immediatly" do
    start_at = NaiveDateTime.utc_now()

    errors =
      %{guest: %{id: 1}}
      |> CreateReservationCommand.build_reservation(%{
        table_id: 1,
        start_at: start_at,
        end_at: start_at
      })
      |> errors_on()

    assert errors.end_at == ["can't be the same as start_at"]
  end
end
