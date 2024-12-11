defmodule ElixirRotation.Repo.Migrations.CreateCollectionsPeople do
  use Ecto.Migration

  def change do
    create table(:collections_people) do
      add :collection_id, references(:collections, on_delete: :nothing)
      add :person_id, references(:people, on_delete: :nothing)
    end

    create unique_index(:collections_people, [:collection_id, :person_id])
  end
end
