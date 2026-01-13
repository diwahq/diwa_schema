defmodule DiwaSchema.Enterprise.ConflictPerformance do
  @moduledoc """
  Ecto schema for conflict resolution performance tracking.
  """
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id

  schema "conflict_performance" do
    belongs_to :context, DiwaSchema.Core.Context

    # In PostgreSQL this is jsonb, we store a list of resolution maps
    field :resolutions, Application.compile_env(:diwa_schema, :resolutions_type, {:array, :map}),
      default: []

    field :false_positive_count, :integer, default: 0
    field :false_negative_count, :integer, default: 0
    field :total_count, :integer, default: 0
    field :window_size, :integer, default: 100

    timestamps()
  end

  def changeset(performance, attrs) do
    performance
    |> cast(attrs, [
      :context_id,
      :resolutions,
      :false_positive_count,
      :false_negative_count,
      :total_count,
      :window_size
    ])
    |> validate_required([:context_id])
    |> unique_constraint(:context_id)
  end
end
