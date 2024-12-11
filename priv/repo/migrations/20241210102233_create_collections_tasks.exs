defmodule ElixirRotation.Repo.Migrations.CreateCollectionsTasks do
  use Ecto.Migration

  def change do
    create table(:collections_tasks) do
      add :collection_id, references(:collections, on_delete: :nothing)
      add :task_id, references(:tasks, on_delete: :nothing)
    end

    create unique_index(:collections_tasks, [:collection_id, :task_id])
  end
end
