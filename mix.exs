defmodule DiwaSchema.MixProject do
  use Mix.Project

  @version "0.1.0"
  @source_url "https://github.com/diwahq/diwa_schema"

  def project do
    [
      app: :diwa_schema,
      version: @version,
      elixir: "~> 1.15",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      package: package(),
      description: description(),
      source_url: @source_url,
      homepage_url: @source_url,
      docs: docs()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:ecto_sql, "~> 3.10"},
      {:postgrex, ">= 0.0.0"},
      {:jason, "~> 1.4"},
      {:pgvector, "~> 0.3.0"},
      {:ecto_sqlite3, "~> 0.17"},
      {:ex_doc, "~> 0.31", only: [:dev, :test], runtime: false}
    ]
  end

  defp description do
    """
    Shared Ecto schemas and migrations for the Diwa ecosystem.
    Provides Core, Team, and Enterprise tier schemas used by diwa-agent and diwa-cloud.
    """
  end

  defp package do
    [
      name: "diwa_schema",
      files: ~w(lib priv mix.exs README.md),
      licenses: ["Apache-2.0"],
      links: %{
        "GitHub" => @source_url,
        "Diwa Agent" => "https://github.com/diwahq/diwa-agent",
        "Diwa Cloud" => "https://github.com/diwahq/diwa-cloud"
      },
      maintainers: ["Diwa HQ"]
    ]
  end

  defp docs do
    [
      main: "readme",
      source_ref: "v#{@version}",
      source_url: @source_url,
      extras: ["README.md"]
    ]
  end
end
