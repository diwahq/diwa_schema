defmodule DiwaSchema.Repo.Migrations.AddSignatureToCommits do
  use Ecto.Migration

  def change do
    alter table(:context_commits) do
      add :signature, :text
      add :signer_pubkey, :string # Storing public key (or ref) directly for verification
    end
  end
end
