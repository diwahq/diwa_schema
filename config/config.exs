import Config

config :diwa_schema, ecto_repos: [DiwaSchema.Repo]

import_config "#{config_env()}.exs"
