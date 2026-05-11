defmodule DiwaSchema.Platform.PerformanceBaseline do
  use Ecto.Schema
  import Ecto.Changeset

  @type t :: %__MODULE__{
          job_type: String.t(),
          model_id: String.t(),
          p50_ms: integer() | nil,
          p95_ms: integer() | nil,
          run_count: integer(),
          last_run_at: DateTime.t() | nil,
          inserted_at: DateTime.t(),
          updated_at: DateTime.t()
        }

  @primary_key {:id, :binary_id, autogenerate: true}
  schema "performance_baselines" do
    field :job_type, :string
    field :model_id, :string
    field :p50_ms, :integer
    field :p95_ms, :integer
    field :run_count, :integer, default: 0
    field :last_run_at, :utc_datetime_usec

    timestamps()
  end

  def changeset(baseline, attrs) do
    baseline
    |> cast(attrs, [:job_type, :model_id, :p50_ms, :p95_ms, :run_count, :last_run_at])
    |> validate_required([:job_type, :model_id])
    |> unique_constraint([:job_type, :model_id])
  end
end
