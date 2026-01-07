defmodule DiwaSchema.Repo do
  use Ecto.Repo,
    otp_app: :diwa_schema,
    adapter: Ecto.Adapters.Postgres
end
