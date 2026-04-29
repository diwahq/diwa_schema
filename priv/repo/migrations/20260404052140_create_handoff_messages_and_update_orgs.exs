defmodule DiwaSchema.Repo.Migrations.CreateHandoffMessagesAndUpdateOrgs do
  use Ecto.Migration

  def change do
    is_sqlite = repo().__adapter__() == Ecto.Adapters.SQLite3
    id_default = if is_sqlite, do: nil, else: fragment("uuid_generate_v4()")

    # 1. Update organizations table with settings
    alter table(:organizations) do
      add :settings, :map, default: "{}"
    end

    # 2. Create handoff_messages table
    create table(:handoff_messages, primary_key: false) do
      add :id, :uuid, primary_key: true, default: id_default
      add :org_id, references(:organizations, type: :uuid, on_delete: :delete_all), null: false
      add :context_id, references(:contexts, type: :uuid, on_delete: :nilify_all)
      add :target_context_id, references(:contexts, type: :uuid, on_delete: :nilify_all)
      
      add :state, :string, null: false, default: "transmitted"
      add :channel, :string, null: false
      add :summary, :text
      add :content_blob, :binary
      add :content_key_id, :uuid
      add :metadata, :map, default: "{}"
      
      add :transmitted_at, :utc_datetime_usec
      add :received_at, :utc_datetime_usec
      add :acknowledged_at, :utc_datetime_usec
      add :archived_at, :utc_datetime_usec
      add :purged_at, :utc_datetime_usec

      # For bidirectional self-filtering (AC-13)
      add :source_context_id, references(:contexts, type: :uuid, on_delete: :nilify_all)
      
      timestamps()
    end

    create index(:handoff_messages, [:org_id])
    create index(:handoff_messages, [:channel])
    create index(:handoff_messages, [:state])
    create index(:handoff_messages, [:source_context_id])
    create index(:handoff_messages, [:target_context_id])
  end
end
