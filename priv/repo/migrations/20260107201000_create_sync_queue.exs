defmodule DiwaSchema.Repo.Migrations.CreateSyncQueue do
  use Ecto.Migration

  def change do
    create table(:sync_queue, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :type, :string, null: false # "context" or "memory"
      add :payload, :map, null: false
      add :status, :string, default: "pending" # pending, processing, failed, completed
      add :priority, :integer, default: 0
      add :attempts, :integer, default: 0
      add :last_error, :text
      add :scheduled_at, :utc_datetime_usec
      
      timestamps(type: :utc_datetime_usec)
    end

    create index(:sync_queue, [:status, :priority, :scheduled_at])
  end
end
