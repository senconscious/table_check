import Config

config :table_check, TableCheck.Repo,
  username: "postgres",
  password: "postgres",
  database: "table_check_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox
