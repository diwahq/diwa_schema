defmodule DiwaSchema.Repo.Migrations.AddDeletedAtToMemories do
  use Ecto.Migration

  def change do
    alter table(:memories) do
      add :deleted_at, :utc_datetime_usec
    end
  end
end
