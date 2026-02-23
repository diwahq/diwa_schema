defmodule Diwa.Repo.Migrations.CreateOrphanReviewLogs do
  use Ecto.Migration

  def change do
    create table(:orphan_review_logs, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :session_id, :uuid, null: false
      add :context_id, :uuid, null: false
      add :action, :string, null: false # 'commit', 'discard', 'recovered', 'partial_commit'
      add :actor, :string, null: false # Original actor
      add :reviewer_actor, :string, null: false # User who reviewed
      add :operation_count, :integer, default: 0
      add :metadata, :jsonb, default: "{}"

      timestamps()
    end

    create index(:orphan_review_logs, [:session_id])
    create index(:orphan_review_logs, [:context_id])
    create index(:orphan_review_logs, [:action])
  end
end
