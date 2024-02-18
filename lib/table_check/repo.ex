defmodule TableCheck.Repo do
  use Ecto.Repo,
    otp_app: :table_check,
    adapter: Ecto.Adapters.Postgres
end
