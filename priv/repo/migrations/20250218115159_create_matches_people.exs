defmodule ElixirRotation.Repo.Migrations.CreateMatchesPeople do
  use Ecto.Migration

  def change do
    create table(:matches_people) do
      add :match_id, references(:matches, on_delete: :nothing)
      add :person_id, references(:people, on_delete: :nothing)
    end
    create unique_index(:matches_people, [:match_id, :person_id])
  end
end
