defmodule DiwaSchema.Repo.Migrations.CreateMemoryVersions do
  use Ecto.Migration

  def change do
    create table(:memory_versions, primary_key: false) do
      add :id, :uuid, primary_key: true, default: fragment("uuid_generate_v4()")
      add :memory_id, references(:memories, type: :uuid, on_delete: :delete_all), null: false
      add :content, :text, null: false
      add :tags, {:array, :string}, default: []
      add :metadata, :jsonb, default: "{}"
      add :operation, :string, null: false # "create", "update", "delete"
      add :actor, :string
      add :reason, :text
      add :parent_version_id, :uuid
      
      timestamps()
    end

    create index(:memory_versions, [:memory_id])
    create index(:memory_versions, [:inserted_at])
  end
end
