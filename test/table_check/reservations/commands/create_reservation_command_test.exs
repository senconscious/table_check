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
end
