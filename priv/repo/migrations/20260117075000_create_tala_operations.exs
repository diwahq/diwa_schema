defmodule DiwaSchema.Repo.Migrations.CreateTalaOperations do
  use Ecto.Migration

  def change do
    create table(:tala_operations, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :session_id, :string
      add :context_id, :string
      add :tool_name, :string
      add :params, :map
      add :actor, :string
      add :status, :string, default: "pending"

      timestamps(updated_at: false)
    end

    create index(:tala_operations, [:session_id])
    create index(:tala_operations, [:status])
  end
end
