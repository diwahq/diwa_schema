defmodule DiwaSchema.Enterprise.ApiKeyTest do
  use ExUnit.Case, async: true
  alias DiwaSchema.Enterprise.ApiKey

  describe "changeset role validation" do
    test "accepts valid roles: admin, member, dew-runner, reviewer" do
      for role <- ["admin", "member", "dew-runner", "reviewer"] do
        attrs = %{
          name: "Test Key",
          key_hash: "hash_#{role}",
          key_prefix: "pref_#{role}",
          organization_id: "00000000-0000-0000-0000-000000000001",
          role: role
        }

        changeset = ApiKey.changeset(%ApiKey{}, attrs)
        assert changeset.valid?, "Expected role '#{role}' to be valid, but got: #{inspect(changeset.errors)}"
      end
    end

    test "rejects invalid roles" do
      for role <- ["superadmin", "planner", "tester", "builder", "invalid"] do
        attrs = %{
          name: "Test Key",
          key_hash: "hash_#{role}",
          key_prefix: "pref_#{role}",
          organization_id: "00000000-0000-0000-0000-000000000001",
          role: role
        }

        changeset = ApiKey.changeset(%ApiKey{}, attrs)
        refute changeset.valid?
        assert %{role: ["is invalid"]} = errors_on(changeset)
      end
    end
  end

  describe "inspect redaction" do
    test "omits key_hash from inspected struct" do
      key = %ApiKey{
        id: "00000000-0000-0000-0000-000000000001",
        name: "Secret Key",
        key_hash: "super_secret_sha256_hash",
        key_prefix: "diwa_live_sec",
        role: "admin"
      }

      inspected = inspect(key)
      refute String.contains?(inspected, "super_secret_sha256_hash")
      refute String.contains?(inspected, "key_hash")
    end
  end

  defp errors_on(changeset) do
    Ecto.Changeset.traverse_errors(changeset, fn {message, opts} ->
      Regex.replace(~r"%{(\w+)}", message, fn _, key ->
        opts |> Keyword.get(String.to_existing_atom(key), key) |> to_string()
      end)
    end)
  end
end
