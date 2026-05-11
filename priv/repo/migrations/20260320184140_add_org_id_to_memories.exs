defmodule DiwaSchema.Repo.Migrations.AddOrgIdToMemories do
  use Ecto.Migration

  def up do
    is_postgres = repo().__adapter__() == Ecto.Adapters.Postgres

    if is_postgres do
      for table <- [:memories, :memory_versions, :hitl_escalations] do
        execute "ALTER TABLE #{table} ADD COLUMN IF NOT EXISTS organization_id uuid REFERENCES organizations(id) ON DELETE CASCADE;"
        execute "CREATE INDEX IF NOT EXISTS #{table}_organization_id_index ON #{table} (organization_id);"
      end
    else
      # SQLite fallback
      alter table(:memories) do
        add :organization_id, :binary_id
      end
      alter table(:memory_versions) do
        add :organization_id, :binary_id
      end
      alter table(:hitl_escalations) do
        add :organization_id, :binary_id
      end
    end

    # Populate existing records with the default System Organization ID
    execute """
    UPDATE memories 
    SET organization_id = '00000000-0000-0000-0000-000000000000'
    WHERE organization_id IS NULL
    """

    execute """
    UPDATE memory_versions 
    SET organization_id = '00000000-0000-0000-0000-000000000000'
    WHERE organization_id IS NULL
    """

    execute """
    UPDATE hitl_escalations 
    SET organization_id = '00000000-0000-0000-0000-000000000000'
    WHERE organization_id IS NULL
    """

    unless is_postgres do
      # On SQLite, we can't easily modify null constraint after the fact without table recreation
      # but for test environments, this is usually acceptable.
    else
      alter table(:memories) do
        modify :organization_id, :uuid, null: false
      end
      alter table(:memory_versions) do
        modify :organization_id, :uuid, null: false
      end
      alter table(:hitl_escalations) do
        modify :organization_id, :uuid, null: false
      end
    end
  end

  def down do
    drop index(:memories, [:organization_id])
    alter table(:memories) do
      remove :organization_id
    end
  end
end
