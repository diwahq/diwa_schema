defmodule DiwaSchema.Repo.Migrations.AddDetailsToHitlEscalations do
  use Ecto.Migration

  def change do
    alter table(:hitl_escalations) do
      add :memory_a_id, references(:memories, type: :binary_id, on_delete: :nilify_all)
      add :memory_b_id, references(:memories, type: :binary_id, on_delete: :nilify_all)
      add :score, :float
    end

    create index(:hitl_escalations, [:memory_a_id])
    create index(:hitl_escalations, [:memory_b_id])
  end
end
