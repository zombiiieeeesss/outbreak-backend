# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
use Mix.Config

config :db,
  ecto_repos: [DB.Repo]

import_config "#{Mix.env}.exs"
