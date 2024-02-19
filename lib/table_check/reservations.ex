defmodule TableCheck.Reservations do
  @moduledoc """
  API interface for reservations
  """

  alias TableCheck.Reservations.CreateReservationCommand

  defdelegate create_reservations(attrs), to: CreateReservationCommand, as: :execute
end
