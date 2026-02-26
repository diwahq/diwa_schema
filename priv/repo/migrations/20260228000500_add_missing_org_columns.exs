defmodule DiwaSchema.Repo.Migrations.AddMissingOrgColumns do
  use Ecto.Migration

  def change do
    alter table(:organizations) do
      add :slug, :string
      add :custom_domain, :string
    end

    create unique_index(:organizations, [:slug])
    create unique_index(:organizations, [:custom_domain])
  end
end
