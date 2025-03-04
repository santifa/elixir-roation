defmodule ElixirRotation.Tasks do
  @moduledoc """
  The Tasks context.
  """

  import Ecto.Query, warn: false
  alias ElixirRotation.Collections.Collection
  alias ElixirRotation.Repo

  alias ElixirRotation.Tasks.Task

  @doc """
  Returns the list of tasks.

  ## Examples

      iex> list_tasks(1)
      [%Task{}, ...]

  """
  def list_tasks(user) do
    Task
    |> where([t], t.user_id == ^user.id)
    |> Repo.all()
  end

  @doc """
  Gets a single task.

  Raises `Ecto.NoResultsError` if the Task does not exist.

  ## Examples

      iex> get_task!(123, 1)
      %Task{}

      iex> get_task!(456, -1)
      ** (Ecto.NoResultsError)

  """
  def get_task!(id, user), do: Repo.get_by!(Task, id: id, user_id: user.id)

  @doc """
  Creates a task.

  ## Examples

      iex> create_task(%{field: value})
      {:ok, %Task{}}

      iex> create_task(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_task(attrs \\ %{}) do
    %Task{}
    |> Task.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a task.

  ## Examples

      iex> update_task(task, %{field: new_value})
      {:ok, %Task{}}

      iex> update_task(task, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_task(%Task{} = task, attrs) do
    task
    |> Task.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a task.

  ## Examples

      iex> delete_task(task)
      {:ok, %Task{}}

      iex> delete_task(task)
      {:error, %Ecto.Changeset{}}

  """
  def delete_task(%Task{} = task) do
    Repo.delete(task)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking task changes.

  ## Examples

      iex> change_task(task)
      %Ecto.Changeset{data: %Task{}}

  """
  def change_task(%Task{} = task, attrs \\ %{}) do
    Task.changeset(task, attrs)
  end

  def get_collection_ids(task_id) do
    query =
      from colls in "collections_tasks",
      where: [task_id: ^task_id],
      select: colls.collection_id
    ids = Repo.all(query)

    Enum.map(ids, fn id -> Repo.get!(Collection, id) end)
  end
end
