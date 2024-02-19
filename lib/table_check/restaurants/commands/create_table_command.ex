defmodule TableCheck.Restaurants.CreateTableCommand do
  alias TableCheck.Restaurants.TableSchema

  alias TableCheck.Repo

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
