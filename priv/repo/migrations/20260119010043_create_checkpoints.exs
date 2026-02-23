defmodule DiwaSchema.Repo.Migrations.CreateCheckpoints do
  use Ecto.Migration

  def change do
    create table(:checkpoints, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :session_id, references(:sessions, type: :binary_id, on_delete: :delete_all), null: false
      add :sequence_number, :integer, null: false
      add :buffer_snapshot, :jsonb, null: false
      add :operation_count, :integer, null: false
      add :byte_size, :integer, null: false
      add :checksum, :string, size: 64, null: false
      
      timestamps(inserted_at: :created_at, updated_at: false)
    end

    create unique_index(:checkpoints, [:session_id, :sequence_number])
    create index(:checkpoints, [:session_id])
    create index(:checkpoints, [:created_at])
  end
end
