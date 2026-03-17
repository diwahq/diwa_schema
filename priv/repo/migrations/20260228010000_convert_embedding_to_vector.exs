defmodule DiwaSchema.Repo.Migrations.ConvertEmbeddingToVector do
  use Ecto.Migration

  def up do
    execute("CREATE EXTENSION IF NOT EXISTS vector")
    execute("ALTER TABLE memories ALTER COLUMN embedding TYPE vector(1536) USING NULL")
  end

  def down do
    execute("ALTER TABLE memories ALTER COLUMN embedding TYPE bytea USING NULL")
  end
end
