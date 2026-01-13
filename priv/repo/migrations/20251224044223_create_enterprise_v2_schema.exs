defmodule DiwaSchema.Repo.Migrations.CreateEnterpriseV2Schema do
  use Ecto.Migration

  def change do
    is_sqlite = repo().__adapter__() == Ecto.Adapters.SQLite3

    unless is_sqlite do
      execute "CREATE EXTENSION IF NOT EXISTS \"uuid-ossp\""
    end

    id_default = if is_sqlite, do: nil, else: fragment("uuid_generate_v4()")
    # SQLite doesn't strictly need :jsonb, but Ecto maps :map to it.
    # Arrays are the main issue. We'll try native expected types and hope for the best
    # or rely on Ecto application logic to handle data types.

    create table(:organizations, primary_key: false) do
      add :id, :uuid, primary_key: true, default: id_default
      add :name, :string, null: false
      add :tier, :string, default: "free"
      timestamps()
    end

    create table(:contexts, primary_key: false) do
      add :id, :uuid, primary_key: true, default: id_default
      add :organization_id, references(:organizations, type: :uuid, on_delete: :delete_all), null: false
      add :name, :string, null: false
      add :description, :text
      add :health_score, :integer, default: 100
      timestamps()
    end

    create table(:memories, primary_key: false) do
      add :id, :uuid, primary_key: true, default: id_default
      add :context_id, references(:contexts, type: :uuid, on_delete: :delete_all), null: false
      add :content, :text, null: false
      add :metadata, :map, null: false, default: "{}" # Changed :jsonb to :map for compat
      add :actor, :string
      add :project, :string
      if is_sqlite do
        add :tags, :text
      else
        add :tags, {:array, :string}
      end
      add :parent_id, references(:memories, type: :uuid, on_delete: :nilify_all)
      add :external_ref, :string
      add :severity, :string
      timestamps()
    end

    create index(:contexts, [:organization_id])
    create index(:contexts, [:name])
    create index(:memories, [:context_id])
    create index(:memories, [:parent_id])

    # GIN indexes are Postgres only
    if is_sqlite do
      create index(:memories, [:tags]) # Simple index
      # Metadata index on JSON/Map in SQLite is not straightforward without expression index
      # Skipping metadata index for SQLite or adding simple one if possible
    else
      create index(:memories, [:tags], using: :gin)
      create index(:memories, [:metadata], using: :gin)
    end
  end
end

