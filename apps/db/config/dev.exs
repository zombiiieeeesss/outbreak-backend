use Mix.Config

config :db, DB.Repo,
  adapter: Ecto.Adapters.Postgres,
  database: "db_dev",
  username: "postgres",
  password: "postgres"
