defmodule DiwaSchema.Enterprise.ApiKey do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id

  schema "api_keys" do
    field :name, :string
    field :key_hash, :string
    field :key_prefix, :string
    field :status, :string, default: "active"
    field :last_used_at, :utc_datetime_usec
    field :expires_at, :utc_datetime_usec

    belongs_to :organization, DiwaSchema.Enterprise.Organization, type: :binary_id

    timestamps(type: :utc_datetime_usec)
  end

  def changeset(api_key, attrs) do
    api_key
    |> cast(attrs, [
      :name,
      :key_hash,
      :key_prefix,
      :organization_id,
      :status,
      :last_used_at,
      :expires_at
    ])
    |> validate_required([:name, :key_hash, :key_prefix, :organization_id])
    |> unique_constraint(:key_hash)
  end
end
