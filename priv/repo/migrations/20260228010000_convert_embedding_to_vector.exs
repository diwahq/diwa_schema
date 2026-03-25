defmodule DiwaSchema.Repo.Migrations.ConvertEmbeddingToVector do
  use Ecto.Migration

  def up do
    if repo().__adapter__() == Ecto.Adapters.Postgres and System.get_env("DIWA_VECTOR_DISABLED") != "true" do
      try do
        execute("CREATE EXTENSION IF NOT EXISTS vector")
        execute("ALTER TABLE memories ALTER COLUMN embedding TYPE vector(1536) USING NULL")
      rescue
        _ -> :ok
      end
    end
  end

  def down do
    if repo().__adapter__() == Ecto.Adapters.Postgres do
      execute("ALTER TABLE memories ALTER COLUMN embedding TYPE bytea USING NULL")
    end
  end
end
