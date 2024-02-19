defmodule TableCheck.Reservations.ReservationQuery do
  @moduledoc """
  Provides listing reservations
  """

  alias TableCheck.Reservations.ReservationSchema

  alias TableCheck.Repo

  @doc """
  List all reservations in system
  """
  @spec list_all() :: [ReservationSchema.t()]
  def list_all do
    Repo.all(ReservationSchema)
  end
end
