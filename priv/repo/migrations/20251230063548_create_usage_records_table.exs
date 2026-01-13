defmodule DiwaSchema.Repo.Migrations.CreateUsageRecordsTable do
  use Ecto.Migration

  def change do
    create table(:usage_records, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :context_id, references(:contexts, type: :binary_id, on_delete: :nothing), null: false
      
      add :provider, :string, null: false
      add :model, :string, null: false
      add :operation, :string, null: false # complete, embed
      
      # Token counting
      add :tokens_input, :integer, default: 0
      add :tokens_output, :integer, default: 0
      add :total_tokens, :integer, default: 0
      
      # Optional cost tracking
      add :cost_estimate, :decimal, precision: 10, scale: 6 # Micro-cents precision
      
      # Latency tracking
      add :duration_ms, :integer
      
      timestamps()
    end

    create index(:usage_records, [:context_id])
    create index(:usage_records, [:inserted_at])
  end
end
