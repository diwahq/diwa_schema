defmodule DiwaSchema.Repo.Migrations.AddHipaaColumnsToTalaOperations do
  use Ecto.Migration

  def change do
    alter table(:tala_operations) do
      add :capability_token, :text
      add :phi_flag, :boolean, default: false
      add :merkle_root, :string
      add :audit_hash, :string
      add :degradation_tier, :string, default: "online"
    end

    create index(:tala_operations, [:phi_flag])
    create index(:tala_operations, [:audit_hash])
  end
end
