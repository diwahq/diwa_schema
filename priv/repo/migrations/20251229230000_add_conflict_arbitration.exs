defmodule DiwaSchema.Repo.Migrations.AddConflictArbitration do
  use Ecto.Migration

  def change do
    # Add Conflict Arbitration configuration to Contexts
    alter table(:contexts) do
      add :conflict_domain, :string, default: "general"
      add :conflict_safety_level, :string, default: "standard"
      add :conflict_base_threshold, :float, default: 0.85
      add :conflict_auto_calibrate, :boolean, default: true
    end

    # Table for storing Conflict Resolution Outcomes (for learning/calibration)
    create table(:conflict_resolution_outcomes, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :context_id, references(:contexts, type: :binary_id, on_delete: :delete_all), null: false
      add :conflict_id, :binary_id, null: false # Ephemeral or log reference
      add :resolution_id, :binary_id
      add :threshold_used, :float
      add :outcome, :string # accepted, rejected, escalated
      add :feedback_score, :float
      
      timestamps()
    end
    
    create index(:conflict_resolution_outcomes, [:context_id])
    create index(:conflict_resolution_outcomes, [:conflict_id])

    # Table for Human-in-the-Loop Escalations
    create table(:hitl_escalations, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :context_id, references(:contexts, type: :binary_id, on_delete: :delete_all), null: false
      add :conflict_id, :binary_id, null: false
      add :status, :string, default: "pending" # pending, resolved, rejected
      add :assigned_to, :string
      add :resolution_notes, :text
      
      timestamps()
    end
    
    create index(:hitl_escalations, [:context_id, :status])

    # Table for Semantic Fingerprints / Checksums
    create table(:memory_checksums, primary_key: false) do
      add :memory_id, references(:memories, type: :binary_id, on_delete: :delete_all), primary_key: true
      add :structure_hash, :string
      add :semantic_hash, :string
      
      timestamps()
    end

    # Cache for Embeddings
    create table(:embedding_cache, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :hash, :string, null: false # Hash of the text content
      add :model, :string, null: false
      add :expires_at, :utc_datetime
      
      # Using a generic type if vector is not available, but spec requested vector.
      # Using a generic type if vector is not available, but spec requested vector.
      # Check sqlite here but we are inside create table.
      # We need to calculate has_vector before 'create table' or use a variable.
      # But create table is a macro. We can put logic inside? Yes.
      
      is_sqlite = Application.get_env(:diwa_agent, DiwaAgent.Repo)[:adapter] == Ecto.Adapters.SQLite3
      has_vector = !is_sqlite && extension_exists?("vector")

      if has_vector do
        add :embedding, :vector, size: 1536 
      else
        add :embedding, :binary 
      end 
      
      timestamps()
    end
    
    create unique_index(:embedding_cache, [:hash, :model])
  end

  defp extension_exists?(name) do
    query = "SELECT 1 FROM pg_extension WHERE extname = '#{name}'"
    case Ecto.Adapters.SQL.query(repo(), query) do
      {:ok, %{rows: [[1]]}} -> true
      _ -> false
    end
  end
end
