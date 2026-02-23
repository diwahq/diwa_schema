defmodule DiwaSchema.Repo.Migrations.CreateWorkspaces do
  use Ecto.Migration

  def change do
    create table(:workspaces, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :name, :string, null: false
      add :layout_type, :string, default: "single"
      add :ide_panel_order, {:array, :string}, default: ["explorer", "chat", "code"]

      timestamps()
    end

    create index(:workspaces, [:name])
  end
end
