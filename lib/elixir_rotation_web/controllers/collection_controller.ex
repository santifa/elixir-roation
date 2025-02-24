defmodule ElixirRotationWeb.CollectionController do
  use ElixirRotationWeb, :controller

  alias ElixirRotation.Matches
  alias ElixirRotation.TaskMatcher
  alias ElixirRotation.Tasks
  alias ElixirRotation.People
  alias ElixirRotation.Collections
  alias ElixirRotation.Collections.Collection

  def get_prepared_collections(user) do
    collections = Collections.list_preloaded_collections(user)

    Enum.map(collections, fn c ->
      changeset = Collections.change_collection(c)
      Map.put(c, :changeset, changeset)
    end)
  end

  def index(conn, _params) do
    user = Pow.Plug.current_user(conn)
    collections = get_prepared_collections(user)
    changeset = Collections.change_collection(%Collection{})
    # Get additional information
    available_people = People.list_people(user)
    available_tasks = Tasks.list_tasks(user)

    render(conn, :index,
      collections: collections,
      changeset: changeset,
      available_people: available_people,
      available_tasks: available_tasks
    )
  end

  @doc """
  Create a new collection with all parameters.
  If no people or tasks are assigned another create function is called which adds
  an empty list instead of the form return value.
  """
  def create(conn, %{
        "collection" => collection_params,
        "assigned_people" => assigned_people,
        "assigned_tasks" => assigned_tasks
      }) do
    user = Pow.Plug.current_user(conn)
    collection_params = Map.put(collection_params, "user_id", user.id)

    case Collections.create_collection(collection_params, assigned_people, assigned_tasks) do
      {:ok, _collection} ->
        conn
        |> put_flash(:info, "Collection created successfully.")
        |> redirect(to: ~p"/collections")

      {:error, %Ecto.Changeset{} = changeset} ->
        collections = get_prepared_collections(user)
        available_people = People.list_people(user)
        available_tasks = Tasks.list_tasks(user)

        new_changeset = Collections.change_collection(%Collection{})
        [{field, {msg, _}} | _] = changeset.errors

        conn
        |> put_flash(:error, "Failed to create collection #{field} with #{msg}")
        |> render(:index,
          collections: collections,
          changeset: new_changeset,
          available_people: available_people,
          available_tasks: available_tasks
        )
    end
  end

  def create(conn, params) when is_map_key(params, "assigned_people") do
    params = Map.put(params, "assigned_tasks", [])
    create(conn, params)
  end

  def create(conn, params) when is_map_key(params, "assigned_tasks") do
    params = Map.put(params, "assigned_people", [])
    create(conn, params)
  end

  def create(conn, params) do
    params = Map.put(params, "assigned_people", [])
    params = Map.put(params, "assigned_tasks", [])
    create(conn, params)
  end

  @doc """
  Update a collection with all parameters and new assigned people and tasks.
  If new people or tasks are assigned the second update function is used which
  add empty lists as the form doesn't return anything.
  """
  def update(conn, %{
        "id" => id,
        "collection" => collection_params,
        "assigned_people" => assigned_people,
        "assigned_tasks" => assigned_tasks
      }) do
    user = Pow.Plug.current_user(conn)
    collection = Collections.get_collection!(id, user)

    case Collections.update_collection(
           collection,
           collection_params,
           assigned_people,
           assigned_tasks
         ) do
      {:ok, _collection} ->
        conn
        |> put_flash(:info, "Collection updated successfully.")
        |> redirect(to: ~p"/collections")

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
          available_tasks: available_tasks
        )
    end
  end

  def update(conn, params) when is_map_key(params, "assigned_people") do
    params = Map.put(params, "assigned_tasks", [])
    update(conn, params)
  end

  def update(conn, params) when is_map_key(params, "assigned_tasks") do
    params = Map.put(params, "assigned_people", [])
    update(conn, params)
  end

  def update(conn, params) do
    params = Map.put(params, "assigned_people", [])
    params = Map.put(params, "assigned_tasks", [])
    update(conn, params)
  end

  def show(conn, %{"id" => id}) do
    user = Pow.Plug.current_user(conn)
    collection = Collections.get_collection_preloaded!(id, user)
    render(conn, :show, collection: collection)
  end

  @doc """
  Delete a collection endpoint.
  """
  def delete(conn, %{"id" => id}) do
    user = Pow.Plug.current_user(conn)
    collection = Collections.get_collection!(id, user)
    {:ok, _collection} = Collections.delete_collection(collection)

    conn
    |> put_flash(:info, "Collection deleted successfully.")
    |> redirect(to: ~p"/collections")
  end

  def run(conn, %{"collection_id" => id}) do
    user = Pow.Plug.current_user(conn)
    collection = Collections.get_collection!(id, user)
    %{:task => task, :person => person} = TaskMatcher.match_tasks(collection, :random_one)
    match = %{user_id: user.id, collection_id: id, random_type: "random_one"}

    case Matches.create_match(match, [task], [person]) do
      {:ok, match} ->
        conn
        |> put_flash(:info, "Match #{match.id} created for #{collection.name}")
        |> redirect(to: ~p"/collections/#{id}")

      {:error, %Ecto.Changeset{} = changeset} ->
        IO.inspect(changeset)

        conn
        |> put_flash(:error, "Creating match failed")
        |> redirect(to: ~p"/collections/#{id}")
    end
  end
end
