defmodule DiwaSchema.Tier do
  @moduledoc """
  Helpers to determine features available in each tier.
  """

  @doc """
  Returns true if the tier is Core, Team, or Enterprise.
  """
  def core?(_), do: true

  @doc """
  Returns true if the tier is Team or Enterprise.
  """
  def team?(tier), do: tier in [:team, :enterprise]

  @doc """
  Returns true only if the tier is Enterprise.
  """
  def enterprise?(tier), do: tier == :enterprise
end
