defmodule TableCheck.Repo.Migrations.CreateReservations do
  use Ecto.Migration

  def up do
    execute("CREATE TYPE reservation_status AS ENUM('pending', 'paid', 'completed', 'cancelled')")

    create table(:reservations) do
      add :status, :reservation_status, null: false, default: "pending"
      add :date, :date, null: false
      add :start_at, :time, null: false
      add :end_at, :time, null: false

      add :table_id, references(:tables, on_delete: :delete_all), null: false
      add :guest_id, references(:guests, on_delete: :delete_all), null: false

      timestamps()
    end
  end

  def down do
    drop table(:reservations)

    execute("DROP TYPE reservation_status")
  end
end
