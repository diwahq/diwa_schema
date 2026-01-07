defmodule DiwaSchema.Repo.Migrations.AddEmbeddingToMemories do
  use Ecto.Migration
  @disable_ddl_transaction true

  def up do
    # Check if embedding column already exists (from previous migrations)
    if !column_exists?(:memories, :embedding) do
      # Try to create extension if needed
      if Diwa.Edition.current() in [:team, :enterprise] do
         # Use direct query to catch error immediately
         try do
           Ecto.Adapters.SQL.query(Diwa.Repo, "CREATE EXTENSION IF NOT EXISTS vector")
         rescue
           _ -> :ok
         end
      end

      # Check if vector extension actually exists now
      has_vector = extension_exists?("vector")

      alter table(:memories) do
        if Diwa.Edition.current() in [:team, :enterprise] and has_vector do
           add :embedding, :vector, size: 384
        else
           add :embedding, :binary
        end
      end
      
      if Diwa.Edition.current() in [:team, :enterprise] and has_vector do
        execute """
        CREATE INDEX memories_embedding_idx ON memories 
        USING hnsw (embedding vector_cosine_ops)
        WITH (m = 16, ef_construction = 64)
        """
      end
    end
  end

  def down do
    if column_exists?(:memories, :embedding) do
      if Diwa.Edition.current() in [:team, :enterprise] do
        execute "DROP INDEX IF EXISTS memories_embedding_idx"
      end
      
      alter table(:memories) do
        remove :embedding
      end
    end
    
    # Note: We don't drop the vector extension as other tables might use it
  end
  
  defp column_exists?(table, column) do
    query = """
    SELECT EXISTS (
      SELECT 1 
      FROM information_schema.columns 
      WHERE table_name = '#{table}' 
      AND column_name = '#{column}'
    )
    """
    
    {:ok, %{rows: [[exists]]}} = Ecto.Adapters.SQL.query(Diwa.Repo, query)
    exists
  end

  defp extension_exists?(name) do
    query = "SELECT 1 FROM pg_extension WHERE extname = '#{name}'"
    case Ecto.Adapters.SQL.query(Diwa.Repo, query) do
      {:ok, %{rows: [[1]]}} -> true
      _ -> false
    end
  end
end
