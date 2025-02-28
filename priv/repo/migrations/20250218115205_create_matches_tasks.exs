defmodule ElixirRotation.Repo.Migrations.CreateMatchesTasks do
  use Ecto.Migration

  def change do
    create table(:matches_tasks) do
      add :match_id, references(:matches, on_delete: :delete_all)
      add :task_id, references(:tasks, on_delete: :delete_all)
    end

    create unique_index(:matches_tasks, [:match_id, :task_id])
  end
end
