defmodule DiwaSchema.Bawi.SagaState do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  @timestamps_opts [type: :utc_datetime_usec]

  schema "saga_states" do
    field :saga_id, :binary_id
    field :status, :string, default: "pending" # pending, in_progress, completed, aborted
    field :step_index, :integer, default: 0
    field :manifest, :map, default: %{}
    field :posture, :string
    field :delivery_strategy, :string # at_most_once, at_least_once
    field :original_run_id, :binary_id
    field :original_run_cost, :decimal
    field :cost_multiplier, :integer, default: 2
    field :organization_id, :binary_id
    field :context_id, :binary_id
    field :backoff_count, :integer, default: 0
    field :audit_trail, :map, default: %{events: []}

    timestamps()
  end

  @doc false
  def changeset(saga_state, attrs) do
    saga_state
    |> cast(attrs, [
      :saga_id, :status, :step_index, :manifest, :posture, :delivery_strategy,
      :original_run_id, :original_run_cost, :cost_multiplier, :organization_id,
      :context_id, :backoff_count, :audit_trail
    ])
    |> validate_required([
      :saga_id, :status, :step_index, :posture, :delivery_strategy,
      :original_run_id, :original_run_cost, :organization_id, :context_id
    ])
    |> validate_inclusion(:status, ["pending", "in_progress", "completed", "aborted"])
    |> validate_inclusion(:delivery_strategy, ["at_most_once", "at_least_once"])
  end
end
