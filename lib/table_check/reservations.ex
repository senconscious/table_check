defmodule TableCheck.Reservations do
  @moduledoc """
  API interface to manage restaurant table reservations
  """

  alias TableCheck.Reservations.ReservationQuery

  alias TableCheck.Reservations.CreateReservationCommand

  defdelegate create_reservations(attrs), to: CreateReservationCommand, as: :execute

  defdelegate list_reservations, to: ReservationQuery, as: :list_all

  defdelegate list_reservations(filters), to: ReservationQuery, as: :list_all
end
