defmodule ElixirRotationWeb.CollectionController do
  use ElixirRotationWeb, :controller

  alias ElixirRotation.Tasks
  alias ElixirRotation.People
  alias ElixirRotation.Collections
  alias ElixirRotation.Collections.Collection

  def index(conn, _params) do
    user = Pow.Plug.current_user(conn)
    collections = Collections.list_preloaded_collections(user)

    render(conn, :index,
      collections: collections)
  end

  def new(conn, _params) do
    user = Pow.Plug.current_user(conn)
    changeset = Collections.change_collection(%Collection{})
    # Get additional information
    available_people = People.list_people(user)
    available_tasks = Tasks.list_tasks(user)

    render(conn, :new,
      changeset: changeset,
      current_people: [],
      available_people: available_people,
      current_tasks: [],
      available_tasks: available_tasks)
  end

  def create(conn, %{"collection" => collection_params,
                     "assigned_people" => assigned_people,
                     "assigned_tasks" => assigned_tasks}) do
    user = Pow.Plug.current_user(conn)
    collection_params = Map.put(collection_params, "user_id", user.id)

    case Collections.create_collection(collection_params, assigned_people, assigned_tasks) do
      {:ok, collection} ->
        conn
        |> put_flash(:info, "Collection created successfully.")
        |> redirect(to: ~p"/collections/#{collection}")

      {:error, %Ecto.Changeset{} = changeset} ->
        # Get additional information
        available_people = People.list_people(user)
        available_tasks = Tasks.list_tasks(user)

        render(conn, :new,
          changeset: changeset,
          current_people: [],
          available_people: available_people,
          current_tasks: [],
          available_tasks: available_tasks)
    end
  end

  @doc """
  Assign empty default values if the form doesn't return anything.
  """
  def create(conn, params) do
    params = Map.put(params, "assigned_people", [])
    params = Map.put(params, "assigned_tasks", [])
    create(conn, params)
  end

  def show(conn, %{"id" => id}) do
    user = Pow.Plug.current_user(conn)
    collection = Collections.get_collection_preloaded!(id, user)
    render(conn, :show, collection: collection)
  end

  def edit(conn, %{"id" => id}) do
    user = Pow.Plug.current_user(conn)
    collection = Collections.get_collection!(id, user)
    changeset = Collections.change_collection(collection)
    # Get additional information
    available_people = People.list_people(user)
    current_people = Collections.get_people_on_collection(collection)
    available_tasks = Tasks.list_tasks(user)
    current_tasks = Collections.get_tasks_on_collection(collection)

    render(conn, :edit,
      collection: collection,
      changeset: changeset,
      current_people: current_people,
      available_people: available_people,
      current_tasks: current_tasks,
      available_tasks: available_tasks)
  end

  def update(conn, %{"id" => id,
                     "collection" => collection_params,
                     "assigned_people" => assigned_people,
                    "assigned_tasks" => assigned_tasks}) do
    user = Pow.Plug.current_user(conn)
    collection = Collections.get_collection!(id, user)

    case Collections.update_collection(
          collection, collection_params, assigned_people, assigned_tasks) do
      {:ok, collection} ->
        conn
        |> put_flash(:info, "Collection updated successfully.")
        |> redirect(to: ~p"/collections/#{collection}")

      {:error, %Ecto.Changeset{} = changeset} ->
        # Get additional information
        available_people = People.list_people(user)
        current_people = Collections.get_people_on_collection(collection)
        available_tasks = Tasks.list_tasks(user)
        current_tasks = Collections.get_tasks_on_collection(collection)

        render(conn, :edit,
          collection: collection,
          changeset: changeset,
          current_people: current_people,
          available_people: available_people,
          current_tasks: current_tasks,
          available_tasks: available_tasks)
    end
  end

  def delete(conn, %{"id" => id}) do
    user = Pow.Plug.current_user(conn)
    collection = Collections.get_collection!(id, user)
    {:ok, _collection} = Collections.delete_collection(collection)

    conn
    |> put_flash(:info, "Collection deleted successfully.")
    |> redirect(to: ~p"/collections")
  end
end
