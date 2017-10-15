use Mix.Config

config :db, DB.Repo,
  adapter: Ecto.Adapters.Postgres,
  database: System.get_env("DB_NAME") || "db_dev",
  username: System.get_env("DB_USERNAME") || "postgres",
  hostname: System.get_env("DB_HOSTNAME") || "localhost",
  port: System.get_env("DB_PORT") || 5432,
  password: "postgres"
