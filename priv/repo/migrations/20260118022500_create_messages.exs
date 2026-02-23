defmodule DiwaSchema.Repo.Migrations.CreateMessages do
  use Ecto.Migration

  def change do
    create table(:messages, primary_key: false) do
      add :id, :string, primary_key: true
      add :role, :string
      add :content, :text
      add :panel_id, references(:panels, type: :string, on_delete: :delete_all)

      timestamps(type: :utc_datetime)
    end

    create index(:messages, [:panel_id])
    create index(:messages, [:inserted_at])
  end
end
