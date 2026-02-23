defmodule DiwaSchema.Repo.Migrations.CreatePanels do
  use Ecto.Migration

  def change do
    create table(:panels, primary_key: false) do
      add :id, :string, primary_key: true
      add :provider, :string, null: false
      add :model, :string
      add :preset_role, :string
      add :position, :integer
      add :workspace_id, references(:workspaces, type: :binary_id, on_delete: :delete_all)

      timestamps()
    end

    create index(:panels, [:workspace_id])
    create index(:panels, [:workspace_id, :position])
  end
end
