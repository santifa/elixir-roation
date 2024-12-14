defmodule ElixirRotationWeb.TaskController do
  use ElixirRotationWeb, :controller

  alias ElixirRotation.Tasks
  alias ElixirRotation.Tasks.Task

  def index(conn, _params) do
    user = Pow.Plug.current_user(conn)
    tasks = Tasks.list_tasks(user)
    tasks = Enum.map(tasks, fn p ->
      ids = Tasks.get_collection_ids(p.id)
      Map.put(p, :collections, ids)
    end)

    render(conn, :index, tasks: tasks)
  end

  def new(conn, _params) do
    changeset = Tasks.change_task(%Task{})
    render(conn, :new, changeset: changeset)
  end

  def create(conn, %{"task" => task_params}) do
    user = Pow.Plug.current_user(conn)
    task_params = Map.put(task_params, "user_id", user.id)

    case Tasks.create_task(task_params) do
      {:ok, task} ->
        conn
        |> put_flash(:info, "Task created successfully.")
        |> redirect(to: ~p"/tasks/#{task}")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :new, changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    user = Pow.Plug.current_user(conn)
    task = Tasks.get_task!(id, user)
    task = Map.put(task, :collections, Tasks.get_collection_ids(task.id))

    render(conn, :show, task: task)
  end

  def edit(conn, %{"id" => id}) do
    user = Pow.Plug.current_user(conn)
    task = Tasks.get_task!(id, user)
    changeset = Tasks.change_task(task)
    render(conn, :edit, task: task, changeset: changeset)
  end

  def update(conn, %{"id" => id, "task" => task_params}) do
    user = Pow.Plug.current_user(conn)
    task = Tasks.get_task!(id, user)

    case Tasks.update_task(task, task_params) do
      {:ok, task} ->
        conn
        |> put_flash(:info, "Task updated successfully.")
        |> redirect(to: ~p"/tasks/#{task}")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :edit, task: task, changeset: changeset)
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
