defmodule DiwaSchema.Repo.Migrations.CreateApiKeys do
  use Ecto.Migration

  def change do
    create table(:api_keys, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :name, :string, null: false
      add :key_hash, :string, null: false
      add :key_prefix, :string, null: false
      add :organization_id, references(:organizations, type: :uuid, on_delete: :delete_all), null: false
      add :status, :string, default: "active"
      add :last_used_at, :utc_datetime_usec
      add :expires_at, :utc_datetime_usec

      timestamps(type: :utc_datetime_usec)
    end

    create unique_index(:api_keys, [:key_hash])
    create index(:api_keys, [:organization_id])
    create index(:api_keys, [:key_prefix])
  end
end
