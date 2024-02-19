defmodule TableCheck.Restaurants.CreateTableCommand do
  @moduledoc """
  Provides business command to create new table for restaurant
  """

  alias TableCheck.Restaurants.TableSchema

  alias TableCheck.Repo

  @type attrs :: %{
          capacity: integer(),
          restaurant_id: integer()
        }

  @spec execute(attrs()) :: {:ok, TableSchema.t()} | {:error, Ecto.Changeset.t()}
  def execute(attrs) do
    attrs
    |> build_new_table()
    |> Repo.insert()
  end

  @doc false
  def build_new_table(attrs) do
    TableSchema.changeset(%TableSchema{}, attrs)
  end
end
