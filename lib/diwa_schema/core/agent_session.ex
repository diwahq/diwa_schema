defmodule DiwaSchema.Core.AgentSession do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  @timestamps_opts [type: :utc_datetime_usec]

  schema "agent_sessions" do
    field :session_token, :string
    field :org_id, :binary_id
    field :context_id, :binary_id
    field :role_identity, :string
    field :display_name, :string
    field :last_heartbeat_at, :utc_datetime
    field :tombstoned_at, :utc_datetime
    field :tombstone_reason, :string

    timestamps()
  end

  def changeset(agent_session, attrs) do
    agent_session
    |> cast(attrs, [
      :session_token,
      :org_id,
      :context_id,
      :role_identity,
      :display_name,
      :last_heartbeat_at,
      :tombstoned_at,
      :tombstone_reason
    ])
    |> validate_required([
      :session_token,
      :org_id,
      :context_id,
      :role_identity,
      :display_name,
      :last_heartbeat_at
    ])
    |> unique_constraint(:session_token)
    |> unique_constraint([:context_id, :role_identity], name: :unique_active_agent_session)
  end
end
