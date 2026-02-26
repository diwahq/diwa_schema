defmodule Diwa.Repo.Migrations.EnforceOrgIdNotNullV2 do
  use Ecto.Migration

  def change do
    # Skip on SQLite as it doesn't support ALTER COLUMN (modify)
    is_sqlite = repo().__adapter__() == Ecto.Adapters.SQLite3
    
    unless is_sqlite do
      alter table(:contexts) do
        modify :organization_id, :uuid, null: false
      end
    end
  end
end
