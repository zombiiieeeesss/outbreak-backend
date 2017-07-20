use Mix.Config

# Configure your database
config :outbreak_backend, OutbreakBackend.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "postgres",
  password: "postgres",
  database: "outbreak_backend_dev",
  hostname: "localhost",
  pool_size: 10
