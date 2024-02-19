defmodule TableCheck.Repo.Migrations.CreateReservations do
  use Ecto.Migration

  def up do
    execute("CREATE EXTENSION IF NOT EXISTS btree_gist")

    create table(:reservations) do
      add :start_at, :naive_datetime, null: false
      add :end_at, :naive_datetime, null: false

      add :table_id, references(:tables, on_delete: :delete_all), null: false
      add :guest_id, references(:guests, on_delete: :delete_all), null: false

      timestamps()
    end

    create index(:reservations, [:table_id])
    # Create index for future
    create index(:reservations, [:guest_id])

    create constraint(:reservations, :time_not_overlap, exclude: ~s|gist(table_id WITH =, tsrange("start_at", "end_at", '[]') WITH &&)|)
  end

  def down do
    drop table(:reservations)
  end
end
