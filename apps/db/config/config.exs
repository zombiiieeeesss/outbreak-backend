# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
use Mix.Config

config :db,
  ecto_repos: [DB.Repo],
  levenshtein_distance:
    System.get_env("LEVENSHTEIN_DISTANCE") || "5"
    |> String.to_integer

import_config "#{Mix.env}.exs"
