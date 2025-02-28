defmodule ElixirRotation.Repo.Migrations.CreateMatches do
  use Ecto.Migration

  def change do
    create table(:matches) do
      add :round, :integer
      add :assignment, :map

      add :user_id, references(:users, on_delete: :delete_all)
      add :collection_id, references(:collections, on_delete: :delete_all)

      timestamps(type: :utc_datetime)
    end

    create index(:matches, [:user_id])
    create index(:matches, [:collection_id])
  end
end
