defmodule Diwa.Repo.Migrations.EnforceOrgIdNotNullV2 do
  use Ecto.Migration

  def change do
    alter table(:contexts) do
      modify :organization_id, :uuid, null: false
    end
  end
end
