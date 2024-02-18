defmodule TableCheck.Repo.Migrations.CreateGuests do
  use Ecto.Migration

  def change do
    create table(:guests) do
      add :name, :text, null: false
      add :phone, :text, null: false
      add :restaurant_id, references(:restaurants, on_delete: :delete_all), null: false

      timestamps()
    end

    create unique_index(:guests, [:restaurant_id, :phone])
  end
end
