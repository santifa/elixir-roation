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
  If no people or tasks are assigned one of the other functions are called which
  add empty lists where the form doesn't return anything.
  """
  def update(conn, %{
        "id" => id,
        "collection" => collection_params,
        "assigned_people" => assigned_people,
        "assigned_tasks" => assigned_tasks
      }) do
    IO.inspect(collection_params)
    user = Pow.Plug.current_user(conn)
    collection = Collections.get_collection!(id, user)
    available_people = People.list_people(user)
    available_tasks = Tasks.list_tasks(user)

    case Collections.update_collection(
           collection,
           collection_params,
           assigned_people,
           assigned_tasks
         ) do
      {:ok, collection} ->
        if "true" == Map.get(collection_params, "redirect") do
          conn
          |> put_flash(:info, "Collection updated successfully.")
          |> redirect(to: ~p"/collections")
        else
          changeset = Collections.change_collection(collection)
          matches = Matches.list_collection_matches(user, collection)
          matches = resolve_assignments(matches)

          conn
          |> put_flash(:info, "Collection updated successfully.")
          |> render(:show,
            collection: collection,
            changeset: changeset,
            available_people: available_people,
            available_tasks: available_tasks,
            matches: matches
          )
        end

      {:error, %Ecto.Changeset{} = changeset} ->
        [{field, {msg, _}} | _] = changeset.errors

        if "true" == Map.get(collection_params, "redirect") do
          collections = get_prepared_collections(user)
          new_changeset = Collections.change_collection(%Collection{})

          conn
          |> put_flash(
            :error,
            "Failed to update collection #{collection.id} #{field} with #{msg}"
          )
          |> render(:index,
            collections: collections,
            changeset: new_changeset,
            available_people: available_people,
            available_tasks: available_tasks
          )
        else
          collection = Collections.get_collection_preloaded!(id, user)
          matches = Matches.list_collection_matches(user, collection)
          matches = resolve_assignments(matches)

          conn
          |> put_flash(
            :error,
            "Failed to update collection #{collection.id} #{field} with #{msg}"
          )
          |> render(:show,
            collection: collection,
            changeset: changeset,
            available_people: available_people,
            available_tasks: available_tasks,
            matches: matches
          )
        end
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
    available_people = People.list_people(user)
    available_tasks = Tasks.list_tasks(user)
    changeset = Collections.change_collection(collection)

    matches = Matches.list_collection_matches(user, collection)
    matches = resolve_assignments(matches) |> Enum.reverse()

    render(conn, :show,
      collection: collection,
      changeset: changeset,
      available_people: available_people,
      available_tasks: available_tasks,
      matches: matches
    )
  end

  @doc """
  Delete a collection endpoint.
  """
  def delete(conn, %{"id" => id}) do
    user = Pow.Plug.current_user(conn)
    collection = Collections.get_collection!(id, user)
    IO.inspect(collection)
    {:ok, _collection} = Collections.delete_collection(collection)

    conn
    |> put_flash(:info, "Collection deleted successfully.")
    |> redirect(to: ~p"/collections")
  end

  def run(conn, %{"collection_id" => id}) do
    user = Pow.Plug.current_user(conn)
    collection = Collections.get_collection!(id, user)

    case TaskMatcher.match_tasks(collection) do
      {:ok, %{:assignment => assignment, :tasks => tasks, :people => people, :round => round}} ->
        match = %{user_id: user.id, collection_id: id, round: round, assignment: assignment}

        case Matches.create_match(match, tasks, people) do
          {:ok, match} ->
            case call_webhook(match, collection) do
              {:ok, response} ->
                IO.inspect(response)

                conn
                |> put_flash(:info, "Match created for #{collection.name} and hook called.")
                |> redirect(to: ~p"/collections/#{id}")
              {:error, msg} ->
                IO.inspect(msg)

                conn
                |> put_flash(:info, "Match created for #{collection.name} and calling failed.")
                |> redirect(to: ~p"/collections/#{id}")
            end

          {:error, %Ecto.Changeset{} = changeset} ->
            IO.inspect(changeset)
            [{field, {msg, _}} | _] = changeset.errors

            conn
            |> put_flash(:error, "Creating match failed for field #{field} with '#{msg}'")
            |> redirect(to: ~p"/collections/#{id}")
        end

      {:error, msg} ->
        conn
        |> put_flash(:error, "Creating match failed with '#{msg}'")
        |> redirect(to: ~p"/collections/#{id}")
    end
  end

  def call_webhook(match, %{
        :webhook => hook,
        :webhook_variable => var
      }) do
    assignments = resolve_assignments(match.assignment, match.people, match.tasks)
    |> Enum.map(fn {person, tasks} -> {person.name,  Enum.map(tasks, &(&1.name)) |> Enum.join(", ")} end)
    |> Enum.map(fn {p, t} -> "#{p} -> #{t}" end)
    |> Enum.join("\n")

    body = "{ \"#{var}\": \"#{assignments}\"}"
    HTTPoison.post(hook, body)
  end

  def call_webhook(_match, _collection) do
    IO.puts("No webhook defined")
  end

  @doc """
  Returns the assignments between people and tasks.
  It resolves the id to the real people and tasks.
  """
  def resolve_assignments({person_id, assigned_tasks}, people, tasks) do
    {id, _} = Integer.parse(person_id)
    person = Enum.find(people, fn p -> p.id == id end)
    tasks = Enum.filter(tasks, fn t -> Enum.any?(assigned_tasks, fn at -> at == t.id end) end)
    {person, tasks}
  end

  def resolve_assignments(assignments, people, tasks) do
    Enum.map(assignments, fn a -> resolve_assignments(a, people, tasks) end)
  end

  def resolve_assignments(matches) do
    matches = Enum.map(matches, fn m -> Map.put(m, :assignment, Map.to_list(m.assignment)) end)

    matches =
      Enum.map(matches, fn m ->
        Map.put(
          m,
          :assignment,
          resolve_assignments(m.assignment, m.people, m.tasks)
        )
      end)

    Enum.with_index(matches)
  end
end
