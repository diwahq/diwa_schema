defmodule DiwaSchema.Core.Context do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  @timestamps_opts [type: :utc_datetime_usec]
  @derive {Jason.Encoder,
           only: [
             :id,
             :name,
             :description,
             :health_score,
             :organization_id,
             :inserted_at,
             :updated_at
           ]}
  schema "contexts" do
    field(:name, :string)
    field(:description, :string)
    field(:health_score, :integer, default: 100)

    belongs_to(:organization, DiwaSchema.Enterprise.Organization)
    has_many(:memories, DiwaSchema.Core.Memory)
    has_one(:plan, DiwaSchema.Team.Plan)
    has_many(:tasks, DiwaSchema.Team.Task)
    has_many(:bindings, DiwaSchema.Core.ContextBinding)
    has_many(:outgoing_relationships, DiwaSchema.Core.ContextRelationship, foreign_key: :source_context_id)
    has_many(:incoming_relationships, DiwaSchema.Core.ContextRelationship, foreign_key: :target_context_id)

    timestamps()
  end

  def changeset(context, attrs) do
    context
    |> cast(attrs, [:name, :description, :health_score, :organization_id])
    |> validate_required([:name, :organization_id])
    |> foreign_key_constraint(:organization_id, name: "contexts_organization_id_fkey")
  end

  def touch_changeset(context, attrs) do
    context
    |> cast(attrs, [:updated_at])
  end
end
