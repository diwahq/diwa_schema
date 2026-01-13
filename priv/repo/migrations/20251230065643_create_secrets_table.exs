defmodule DiwaSchema.Repo.Migrations.CreateSecretsTable do
  use Ecto.Migration

  def change do
    create table(:secrets, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :key, :string, null: false
      add :value_encrypted, :binary, null: false
      # Optional: Link to context/org/user if needed for multi-tenancy
      # add :context_id, references(:contexts, type: :binary_id)
      
      timestamps()
    end

    create unique_index(:secrets, [:key])
  end
end
