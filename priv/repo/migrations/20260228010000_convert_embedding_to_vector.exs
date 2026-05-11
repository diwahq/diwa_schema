defmodule DiwaSchema.Repo.Migrations.ConvertEmbeddingToVector do
  use Ecto.Migration

  def up do
    # Only run Postgres-specific vector conversion if the adapter is Postgres
    # and DIWA_VECTOR_DISABLED is not true.
    if repo().__adapter__() == Ecto.Adapters.Postgres and
         System.get_env("DIWA_VECTOR_DISABLED") != "true" do
      has_extension_available =
        case repo().query("SELECT 1 FROM pg_available_extensions WHERE name = 'vector'") do
          {:ok, %{rows: [[1]]}} -> true
          _ -> false
        end

      if has_extension_available do
        execute("CREATE EXTENSION IF NOT EXISTS vector")
        execute("ALTER TABLE memories ALTER COLUMN embedding TYPE vector(1536) USING NULL")
      end
    end
  end

  def down do
    if repo().__adapter__() == Ecto.Adapters.Postgres do
      execute("ALTER TABLE memories ALTER COLUMN embedding TYPE bytea USING NULL")
    end
  end
end
