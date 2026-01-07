defmodule DiwaSchema.Repo.Migrations.CreateConflictPerformance do
  use Ecto.Migration

  def change do
    create table(:conflict_performance, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :context_id, references(:contexts, type: :binary_id, on_delete: :delete_all), null: false
      
      # Store recent resolution history as JSONB array
      # Each entry: %{memory_a_id, memory_b_id, result, user_feedback, timestamp}
      add :resolutions, :jsonb, default: "[]"
      
      # Performance metrics
      add :false_positive_count, :integer, default: 0  # Detected conflict but wasn't
      add :false_negative_count, :integer, default: 0  # Missed actual conflict
      add :total_count, :integer, default: 0           # Total detections
      
      # Sliding window size for metrics
      add :window_size, :integer, default: 100
      
      timestamps()
    end

    # One performance record per context
    create unique_index(:conflict_performance, [:context_id])
    
    # Index for efficient queries
    create index(:conflict_performance, [:updated_at])
  end
end
