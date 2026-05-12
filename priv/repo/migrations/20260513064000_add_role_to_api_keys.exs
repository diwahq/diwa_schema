defmodule DiwaSchema.Repo.Migrations.AddRoleToApiKeys do
  use Ecto.Migration

  def up do
    alter table(:api_keys) do
      add :role, :string, default: "member", null: false
    end

    # Promote Claude key to admin
    # ID: 5b188950-17b3-47e9-836e-72288c0177be
    execute "UPDATE api_keys SET role = 'admin' WHERE id = '5b188950-17b3-47e9-836e-72288c0177be'"
  end

  def down do
    alter table(:api_keys) do
      remove :role
    end
  end
end
