defmodule TableCheck.Reservations do
  alias TableCheck.Reservations.CreateReservationCommand

  defdelegate create_reservations(attrs), to: CreateReservationCommand, as: :execute
end
