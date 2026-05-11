defmodule DiwaSchema.Repo.Migrations.AddVectorExtensionAndEmbeddings do
  use Ecto.Migration

  def up do
    if repo().__adapter__() == Ecto.Adapters.Postgres and 
       System.get_env("DIWA_SKIP_PGVECTOR") != "true" and 
       System.get_env("DIWA_VECTOR_DISABLED") != "true" do
      # Even tighter check: avoid ANY query that might trigger extension loading if not present
      # Query pg_available_extensions to see if the 'vector' control file is present
      # This avoids a fatal error on CREATE EXTENSION if pgvector is not installed
      has_extension_available =
        case repo().query("SELECT 1 FROM pg_available_extensions WHERE name = 'vector'") do
          {:ok, %{rows: [[1]]}} -> true
          _ -> false
        end

      if has_extension_available do
        execute "CREATE EXTENSION IF NOT EXISTS vector"
      end
    end
  end

  def down do
    # Operations commented out as they were inconsistent with up()
    
    # execute "DROP INDEX IF EXISTS memories_embedding_index"
    
    # alter table(:memories) do
    #   remove :embedding
    # end

    # We don't drop the extension as other apps might use it
    # execute "DROP EXTENSION IF EXISTS vector"
  end
end
