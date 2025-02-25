defmodule ElixirRotation.Repo.Migrations.CreateCollections do
  use Ecto.Migration

  def change do
    create table(:collections) do
      add :name, :string
      add :description, :text
      add :webhook, :string
      add :schedule, :string
      add :algorithm, :string
      add :put_back, :boolean
      add :user_id, references(:users, on_delete: :delete_all)

      timestamps(type: :utc_datetime)
    end

    create index(:collections, [:user_id])
  end
end
