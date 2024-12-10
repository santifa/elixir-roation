defmodule ElixirRotationWeb.CollectionController do
  use ElixirRotationWeb, :controller

  alias ElixirRotation.Collections
  alias ElixirRotation.Collections.Collection

  def index(conn, _params) do
    user = Pow.Plug.current_user(conn)
    collections = Collections.list_collections(user)
    render(conn, :index, collections: collections)
  end

  def new(conn, _params) do
    changeset = Collections.change_collection(%Collection{})
    render(conn, :new, changeset: changeset)
  end

  def create(conn, %{"collection" => collection_params}) do
    user = Pow.Plug.current_user(conn)
    collection_params = Map.put(collection_params, "user_id", user)

    case Collections.create_collection(collection_params) do
      {:ok, collection} ->
        conn
        |> put_flash(:info, "Collection created successfully.")
        |> redirect(to: ~p"/collections/#{collection}")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :new, changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    user = Pow.Plug.current_user(conn)
    collection = Collections.get_collection!(id, user)
    render(conn, :show, collection: collection)
  end

  def edit(conn, %{"id" => id}) do
    user = Pow.Plug.current_user(conn)
    collection = Collections.get_collection!(id, user)
    changeset = Collections.change_collection(collection)
    render(conn, :edit, collection: collection, changeset: changeset)
  end

  def update(conn, %{"id" => id, "collection" => collection_params}) do
    user = Pow.Plug.current_user(conn)
    collection = Collections.get_collection!(id, user)

    case Collections.update_collection(collection, collection_params) do
      {:ok, collection} ->
        conn
        |> put_flash(:info, "Collection updated successfully.")
        |> redirect(to: ~p"/collections/#{collection}")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :edit, collection: collection, changeset: changeset)
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
