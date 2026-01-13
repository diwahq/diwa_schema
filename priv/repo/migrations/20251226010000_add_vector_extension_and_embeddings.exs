defmodule DiwaSchema.Repo.Migrations.AddVectorExtensionAndEmbeddings do
  use Ecto.Migration

  def up do
    if repo().__adapter__() == Ecto.Adapters.Postgres do
      execute "CREATE EXTENSION IF NOT EXISTS vector"
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
