defmodule DiwaSchema.Repo.Migrations.AddEmbeddingToMemories do
  use Ecto.Migration
  @disable_ddl_transaction true

  def up do
    is_sqlite = repo().__adapter__ == Ecto.Adapters.SQLite3

    # Check if embedding column already exists (from previous migrations)
    if !column_exists?(:memories, :embedding, is_sqlite) do
      
      has_vector = 
        if is_sqlite do
          false
        else
          # Try to create extension if needed
          try do
             Ecto.Adapters.SQL.query(repo(), "CREATE EXTENSION IF NOT EXISTS vector")
          rescue _ -> :ok end
          
          extension_exists?("vector")
        end

      alter table(:memories) do
        if has_vector do
           add :embedding, :vector, size: 384
        else
           # Fallback for SQLite or Postgres without vector extension
           add :embedding, :binary
        end
      end
      
      if has_vector do
        execute """
        CREATE INDEX memories_embedding_idx ON memories 
        USING hnsw (embedding vector_cosine_ops)
        WITH (m = 16, ef_construction = 64)
        """
      end
    end
  end

  def down do
    is_sqlite = repo().__adapter__ == Ecto.Adapters.SQLite3

    if column_exists?(:memories, :embedding, is_sqlite) do
      unless is_sqlite do
        execute "DROP INDEX IF EXISTS memories_embedding_idx"
      end
      
      alter table(:memories) do
        remove :embedding
      end
    end
  end
  
  defp column_exists?(table, column, is_sqlite) do
    if is_sqlite do
      {:ok, result} = Ecto.Adapters.SQL.query(repo(), "PRAGMA table_info(#{table})")
      Enum.any?(result.rows, fn row -> Enum.at(row, 1) == Atom.to_string(column) end)
    else
      query = """
      SELECT EXISTS (
        SELECT 1 
        FROM information_schema.columns 
        WHERE table_name = '#{table}' 
        AND column_name = '#{column}'
      )
      """
      {:ok, %{rows: [[exists]]}} = Ecto.Adapters.SQL.query(repo(), query)
      exists
    end
  end

  defp extension_exists?(name) do
    query = "SELECT 1 FROM pg_extension WHERE extname = '#{name}'"
    case Ecto.Adapters.SQL.query(repo(), query) do
      {:ok, %{rows: [[1]]}} -> true
      _ -> false
    end
  end
end
