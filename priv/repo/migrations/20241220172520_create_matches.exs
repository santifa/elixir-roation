defmodule ElixirRotation.Repo.Migrations.CreateMatches do
  use Ecto.Migration

  def change do
    create table(:matches) do
      add :round, :integer
      add :assignment, :map

      add :user_id, references(:users, on_delete: :nothing)
      add :collection_id, references(:collections, on_delete: :nothing)

      timestamps(type: :utc_datetime)
    end

    create index(:matches, [:user_id])
    create index(:matches, [:collection_id])
  end
end
