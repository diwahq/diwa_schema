defmodule DiwaSchema.Repo.Migrations.AddFtsToMemories do
  use Ecto.Migration

  def up do
    is_sqlite = repo().__adapter__() == Ecto.Adapters.SQLite3
    
    unless is_sqlite do
      execute "ALTER TABLE memories ADD COLUMN tsv_content tsvector"
      execute """
      CREATE INDEX memories_fts_idx ON memories USING GIN (tsv_content)
      """
      
      # Trigger to update tsvector on insert/update
      execute """
      CREATE TRIGGER tsvectorupdate BEFORE INSERT OR UPDATE
      ON memories FOR EACH ROW EXECUTE PROCEDURE
      tsvector_update_trigger(tsv_content, 'pg_catalog.english', content)
      """

      # Populate existing data
      execute "UPDATE memories SET tsv_content = to_tsvector('english', content)"
    end
  end

  def down do
    is_sqlite = repo().__adapter__() == Ecto.Adapters.SQLite3

    unless is_sqlite do
      execute "DROP TRIGGER tsvectorupdate ON memories"
      execute "DROP INDEX memories_fts_idx"
      alter table(:memories) do
        remove :tsv_content
      end
    end
  end
end
