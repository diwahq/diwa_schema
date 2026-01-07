defmodule DiwaSchema.Repo.Migrations.CreateUgatTables do
  use Ecto.Migration

  def change do
    # 1. Context Bindings (for Auto-Detection)
    create table(:context_bindings, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :context_id, references(:contexts, type: :binary_id, on_delete: :delete_all), null: false
      add :binding_type, :string, null: false # e.g., "git_remote", "path", "env_var"
      add :value, :string, null: false        # e.g., "git@github.com:..."
      add :metadata, :map, default: "{}"
      
      timestamps(type: :utc_datetime_usec)
    end

    create index(:context_bindings, [:context_id])
    create unique_index(:context_bindings, [:context_id, :binding_type, :value])

    # 2. Context Relationships (for Context-Level Linking)
    create table(:context_relationships, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :source_context_id, references(:contexts, type: :binary_id, on_delete: :delete_all), null: false
      add :target_context_id, references(:contexts, type: :binary_id, on_delete: :delete_all), null: false
      add :relationship_type, :string, null: false # e.g., "depends_on", "relates_to"
      add :metadata, :map, default: "{}"

      timestamps(type: :utc_datetime_usec)
    end

    create index(:context_relationships, [:source_context_id])
    create index(:context_relationships, [:target_context_id])
    create unique_index(:context_relationships, [:source_context_id, :target_context_id, :relationship_type])
  end
end
