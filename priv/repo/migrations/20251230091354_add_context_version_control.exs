defmodule DiwaSchema.Repo.Migrations.AddContextVersionControl do
  use Ecto.Migration

  def change do
    create table(:context_registry, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :name, :string, null: false
      add :context_id, references(:contexts, type: :binary_id, on_delete: :delete_all)
      add :platform_ref, :map, default: "{}"
      
      timestamps()
    end
    
    create unique_index(:context_registry, [:name])

    create table(:context_commits, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :context_id, references(:contexts, type: :binary_id, on_delete: :delete_all)
      add :hash, :string, null: false
      add :parent_hash, :string
      add :platform, :string, null: false
      add :message, :text
      
      timestamps()
    end
    
    create index(:context_commits, [:context_id])
    create index(:context_commits, [:hash])
  end
end
