defmodule DiwaSchema.Types.JsonArray do
  use Ecto.Type

  def type, do: :string

  def cast(list) when is_list(list), do: {:ok, list}
  def cast(_), do: :error

  def load(data) when is_binary(data) do
    case Jason.decode(data) do
      {:ok, list} when is_list(list) -> {:ok, list}
      {:ok, _} -> :error
      error -> error
    end
  end

  def load(_), do: :error

  def dump(list) when is_list(list) do
    Jason.encode(list)
  end

  def dump(_), do: :error

  def embed_as(_), do: :self
  def equal?(term1, term2), do: term1 == term2
end
