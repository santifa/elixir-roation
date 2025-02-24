defmodule ElixirRotationWeb.TaskController do
  use ElixirRotationWeb, :controller

  alias ElixirRotation.Tasks
  alias ElixirRotation.Tasks.Task

  def get_prepared_tasks(user, id, changeset \\ {}) do
    tasks = Tasks.list_tasks(user)

    tasks =
      Enum.map(tasks, fn t ->
        ids = Tasks.get_collection_ids(t.id)
        Map.put(t, :collections, ids)
      end)

    Enum.map(tasks, fn t ->
      if t.id == id do
        Map.put(t, :changeset, changeset)
      else
        changeset = Tasks.change_task(t)
        Map.put(t, :changeset, changeset)
      end
    end)
  end

  def index(conn, _params) do
    user = Pow.Plug.current_user(conn)
    tasks = get_prepared_tasks(user, -1)
    new_task = Tasks.change_task(%Task{})

    render(conn, :index, tasks: tasks, changeset: new_task)
  end

  def create(conn, %{"task" => task_params}) do
    user = Pow.Plug.current_user(conn)
    task_params = Map.put(task_params, "user_id", user.id)

    case Tasks.create_task(task_params) do
      {:ok, _task} ->
        conn
        |> put_flash(:info, "Task created successfully.")
        |> redirect(to: ~p"/tasks")

      {:error, %Ecto.Changeset{} = changeset} ->
        tasks = get_prepared_tasks(user, task_params.id, changeset)
        new_task = Tasks.change_task(%Task{})
        [{field, {msg, _}} | _] = changeset.errors

        conn
        |> put_flash(:error, "Failed to create task #{field} with #{msg}")
        |> render(:index, tasks: tasks, changeset: new_task)
    end
  end

  def update(conn, %{"id" => id, "task" => task_params}) do
    user = Pow.Plug.current_user(conn)
    task = Tasks.get_task!(id, user)

    case Tasks.update_task(task, task_params) do
      {:ok, _task} ->
        conn
        |> put_flash(:info, "Task updated successfully.")
        |> redirect(to: ~p"/tasks")

      {:error, %Ecto.Changeset{} = changeset} ->
        tasks = get_prepared_tasks(user, task.id, changeset)

        new_task = Tasks.change_task(%Task{})
        [{field, {msg, _}} | _] = changeset.errors

        conn
        |> put_flash(:error, "Failed to change person #{task.id} #{field} with #{msg}")
        |> render(:index, tasks: tasks, changeset: new_task)
    end
  end

  def delete(conn, %{"id" => id}) do
    user = Pow.Plug.current_user(conn)
    task = Tasks.get_task!(id, user)
    {:ok, _task} = Tasks.delete_task(task)

    conn
    |> put_flash(:info, "Task deleted successfully.")
    |> redirect(to: ~p"/tasks")
  end
end
