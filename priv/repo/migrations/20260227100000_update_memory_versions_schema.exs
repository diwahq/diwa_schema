defmodule Diwa.Repo.Migrations.UpdateMemoryVersionsSchema do
  use Ecto.Migration

  def change do
    alter table(:memory_versions) do
      add :version_number, :integer
    end

    execute "UPDATE memory_versions SET version_number = 1 WHERE version_number IS NULL"
  end
end
