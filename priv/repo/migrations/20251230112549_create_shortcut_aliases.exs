defmodule DiwaSchema.Repo.Migrations.CreateShortcutAliases do
  use Ecto.Migration

  def change do
    create table(:shortcut_aliases, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :alias_name, :string, null: false
      add :target_tool, :string, null: false
      add :args_schema, {:array, :string}, default: []

      timestamps()
    end

    create unique_index(:shortcut_aliases, [:alias_name])
  end
end
