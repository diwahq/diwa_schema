defmodule DiwaSchema.Core.ContextBinding do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  @timestamps_opts [type: :utc_datetime_usec]
  @derive {Jason.Encoder,
           only: [:id, :context_id, :binding_type, :value, :metadata, :inserted_at]}

  schema "context_bindings" do
    field :binding_type, :string
    field :value, :string
    field :metadata, :map, default: %{}

    belongs_to :context, DiwaSchema.Core.Context

    timestamps()
  end

  def changeset(binding, attrs) do
    binding
    |> cast(attrs, [:context_id, :binding_type, :value, :metadata])
    |> validate_required([:context_id, :binding_type, :value])
    |> unique_constraint([:context_id, :binding_type, :value])
  end
end
