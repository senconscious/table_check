import Config

config :table_check, ecto_repos: [TableCheck.Repo]

config :table_check, TableCheck.Repo,
  database: "table_check_dev",
  username: "postgres",
  password: "postgres",
  hostname: "localhost",
  port: "5432"

import_config "#{config_env()}.exs"
