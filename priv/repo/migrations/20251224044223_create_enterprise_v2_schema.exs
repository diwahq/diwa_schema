defmodule DiwaSchema.Repo.Migrations.CreateEnterpriseV2Schema do
  use Ecto.Migration

  def change do
    execute "CREATE EXTENSION IF NOT EXISTS \"uuid-ossp\""

    create table(:organizations, primary_key: false) do
      add :id, :uuid, primary_key: true, default: fragment("uuid_generate_v4()")
      add :name, :string, null: false
      add :tier, :string, default: "free"
      timestamps()
    end

    create table(:contexts, primary_key: false) do
      add :id, :uuid, primary_key: true, default: fragment("uuid_generate_v4()")
      add :organization_id, references(:organizations, type: :uuid, on_delete: :delete_all), null: false
      add :name, :string, null: false
      add :description, :text
      add :health_score, :integer, default: 100
      timestamps()
    end

    create table(:memories, primary_key: false) do
      add :id, :uuid, primary_key: true, default: fragment("uuid_generate_v4()")
      add :context_id, references(:contexts, type: :uuid, on_delete: :delete_all), null: false
      add :content, :text, null: false
      add :metadata, :jsonb, null: false, default: "{}"
      add :actor, :string
      add :project, :string
      add :tags, {:array, :string}
      add :parent_id, references(:memories, type: :uuid, on_delete: :nilify_all)
      add :external_ref, :string
      add :severity, :string
      timestamps()
    end

    create index(:contexts, [:organization_id])
    create index(:contexts, [:name])
    create index(:memories, [:context_id])
    create index(:memories, [:parent_id])
    create index(:memories, [:tags], using: :gin)
    create index(:memories, [:metadata], using: :gin)
  end
end
