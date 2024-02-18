defmodule TableCheck.Repo.Migrations.CreateTables do
  use Ecto.Migration

  def change do
    create table(:tables) do
      add :capacity, :integer, null: false
      add :restaurant_id, references(:restaurants, on_delete: :delete_all)

      timestamps()
    end

    create constraint(:tables, :capacity_must_be_positive, check: "capacity > 0")
  end
end
