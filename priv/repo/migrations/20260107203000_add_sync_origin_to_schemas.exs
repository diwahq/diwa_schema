defmodule DiwaSchema.Repo.Migrations.AddSyncOriginToSchemas do
  use Ecto.Migration

  def change do
    alter table(:contexts) do
      add :sync_origin, :string, default: "cloud" # local, cloud
      add :remote_id, :uuid
    end

    alter table(:memories) do
      add :sync_origin, :string, default: "cloud" # local, cloud
      add :remote_id, :uuid
    end

    create index(:contexts, [:sync_origin])
    create index(:memories, [:sync_origin])
  end
end
