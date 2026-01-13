defmodule DiwaSchema.Core.ContextRelationship do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  @timestamps_opts [type: :utc_datetime_usec]
  @derive {Jason.Encoder,
           only: [
             :id,
             :source_context_id,
             :target_context_id,
             :relationship_type,
             :metadata,
             :inserted_at
           ]}

  schema "context_relationships" do
    field :relationship_type, :string
    field :metadata, :map, default: %{}

    belongs_to :source_context, DiwaSchema.Core.Context
    belongs_to :target_context, DiwaSchema.Core.Context

    timestamps()
  end

  def changeset(relationship, attrs) do
    relationship
    |> cast(attrs, [:source_context_id, :target_context_id, :relationship_type, :metadata])
    |> validate_required([:source_context_id, :target_context_id, :relationship_type])
    |> check_loop()
    |> unique_constraint([:source_context_id, :target_context_id, :relationship_type],
      name: "context_relationships_source_context_id_target_context_id_relat"
    )
  end

  defp check_loop(changeset) do
    source = get_field(changeset, :source_context_id)
    target = get_field(changeset, :target_context_id)

    if source && target && source == target do
      add_error(changeset, :target_context_id, "cannot cache relationship to self")
    else
      changeset
    end
  end
end
