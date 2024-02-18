defmodule TableCheck.Repo.Migrations.CreateRestaurants do
  use Ecto.Migration

  def change do
    create table(:restaurants) do
      add :name, :text, null: false

      timestamps()
    end
  end
end
