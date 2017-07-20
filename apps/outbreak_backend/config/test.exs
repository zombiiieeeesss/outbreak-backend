use Mix.Config

# Configure your database
config :outbreak_backend, OutbreakBackend.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "postgres",
  password: "postgres",
  database: "outbreak_backend_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox
