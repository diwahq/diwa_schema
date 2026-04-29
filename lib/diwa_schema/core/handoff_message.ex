defmodule DiwaSchema.Core.HandoffMessage do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  @timestamps_opts [type: :utc_datetime]

  @derive {Jason.Encoder,
           only: [
             :id,
             :org_id,
             :context_id,
             :target_context_id,
             :state,
             :channel,
             :summary,
             :metadata,
             :transmitted_at,
             :received_at,
             :acknowledged_at,
             :archived_at,
             :purged_at,
             :source_context_id,
             :broadcast,
             :message_type,
             :reply_to_context_id,
             :reply_to_session_token,
             :workspace,
             :kaban_doc_id,
             :kaban_doc_version,
             :kaban_doc_hash,
             :inserted_at,
             :updated_at
           ]}
  schema "handoff_messages" do
    field(:org_id, :binary_id)
    field(:context_id, :binary_id)
    field(:target_context_id, :binary_id)
    field(:source_context_id, :binary_id)
    field(:state, :string, default: "transmitted")
    field(:channel, :string)
    field(:summary, :string)
    field(:content_blob, :binary)
    field(:content_key_id, :binary_id)
    field(:metadata, :map, default: %{})
    
    field(:transmitted_at, :utc_datetime)
    field(:received_at, :utc_datetime)
    field(:acknowledged_at, :utc_datetime)
    field(:archived_at, :utc_datetime)
    field(:purged_at, :utc_datetime)
 
    # Identity Routing (FIX-017)
    field(:agent_role, :string)
    field(:session_token, :string)
    field(:routing_mode, :string) # "identity" or "channel"
    field(:target_role_identity, :string)
    field(:threat_surface, :boolean, default: false)
    field(:deprecation_warning, :boolean, default: false)
    field(:from_display_name, :string)
    field(:broadcast, :boolean, default: false)
    field(:message_type, :string)

    # SABI Envelope (FIX-018)
    field(:reply_to_context_id, :binary_id)
    field(:reply_to_session_token, :string)
    field(:workspace, :string)

    # TKD-014 v1.0 pointer fields
    field(:kaban_doc_id, :binary_id)
    field(:kaban_doc_version, :string)
    field(:kaban_doc_hash, :string)

    belongs_to(:context, DiwaSchema.Core.Context, define_field: false)
    belongs_to(:target_context, DiwaSchema.Core.Context, foreign_key: :target_context_id, define_field: false)
    belongs_to(:source_context, DiwaSchema.Core.Context, foreign_key: :source_context_id, define_field: false)
    belongs_to(:organization, DiwaSchema.Enterprise.Organization, foreign_key: :org_id, define_field: false)

    timestamps()
  end

  def changeset(handoff_message, attrs) do
    handoff_message
    |> cast(attrs, [
      :org_id,
      :context_id,
      :target_context_id,
      :state,
      :channel,
      :summary,
      :content_blob,
      :content_key_id,
      :metadata,
      :transmitted_at,
      :received_at,
      :acknowledged_at,
      :archived_at,
      :purged_at,
      :source_context_id,
      :agent_role,
      :session_token,
      :routing_mode,
      :target_role_identity,
      :threat_surface,
      :deprecation_warning,
      :from_display_name,
      :broadcast,
      :message_type,
      :reply_to_context_id,
      :reply_to_session_token,
      :workspace,
      :kaban_doc_id,
      :kaban_doc_version,
      :kaban_doc_hash
    ])
    |> validate_required([:org_id, :context_id, :channel, :state])
    |> validate_inclusion(:routing_mode, ["identity", "channel"])
    |> validate_inclusion(:state, ["transmitted", "received", "acknowledged", "archived", "purged"])
    |> validate_kaban_pointer_consistency()
  end

  # Q8: Pointer-population atomicity (all-three-or-zero invariant)
  defp validate_kaban_pointer_consistency(changeset) do
    doc_id = get_field(changeset, :kaban_doc_id)
    doc_version = get_field(changeset, :kaban_doc_version)
    doc_hash = get_field(changeset, :kaban_doc_hash)
    
    has_any = not is_nil(doc_id) or not is_nil(doc_version) or not is_nil(doc_hash)
    has_all = not is_nil(doc_id) and not is_nil(doc_version) and not is_nil(doc_hash)

    if has_any and not has_all do
      add_error(changeset, :kaban_doc_id, "all three kaban pointer fields must be provided together")
    else
      changeset
    end
  end
end
