defmodule TableCheck.Repo.Migrations.CreateTables do
  use Ecto.Migration

  def change do
    create table(:tables) do
      add :capacity, :integer, null: false
      add :restaurant_id, references(:restaurants, on_delete: :delete_all), null: false

      timestamps()
    end

    create index(:tables, [:restaurant_id])

    create constraint(:tables, :capacity_must_be_positive, check: "capacity > 0")
  end
end
