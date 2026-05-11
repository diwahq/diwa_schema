defmodule DiwaSchema.Bawi.SagaStateTest do
  use ExUnit.Case, async: true
  alias DiwaSchema.Bawi.SagaState

  describe "changeset/2" do
    @valid_attrs %{
      saga_id: Ecto.UUID.generate(),
      status: "pending",
      posture: "at_least_once",
      current_step_index: 0,
      payload: %{"order_id" => 123}
    }

    test "with valid attributes" do
      changeset = SagaState.changeset(%SagaState{}, @valid_attrs)
      assert changeset.valid?
    end

    test "requires mandatory fields" do
      changeset = SagaState.changeset(%SagaState{}, %{})
      refute changeset.valid?
      
      errors = errors_on(changeset)
      assert %{saga_id: ["can't be blank"], posture: ["can't be blank"]} = errors
    end

    test "validates status inclusion" do
      attrs = Map.put(@valid_attrs, :status, "invalid_status")
      changeset = SagaState.changeset(%SagaState{}, attrs)
      refute changeset.valid?
      assert %{status: ["is invalid"]} = errors_on(changeset)
    end

    test "validates posture inclusion" do
      attrs = Map.put(@valid_attrs, :posture, "invalid_posture")
      changeset = SagaState.changeset(%SagaState{}, attrs)
      refute changeset.valid?
      assert %{posture: ["is invalid"]} = errors_on(changeset)
    end
  end

  defp errors_on(changeset) do
    Ecto.Changeset.traverse_errors(changeset, fn {msg, opts} ->
      Enum.reduce(opts, msg, fn {key, value}, acc ->
        String.replace(acc, "%{#{key}}", to_string(value))
      end)
    end)
  end
end
