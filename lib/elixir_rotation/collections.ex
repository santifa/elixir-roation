defmodule ElixirRotation.Collections do
  @moduledoc """
  The Collections context.
  """

  import Ecto.Query, warn: false
  alias ElixirRotation.Accounts.User
  alias ElixirRotation.Repo

  alias ElixirRotation.Collections.Collection

  @doc """
  Returns the list of collections.

  ## Examples

      iex> list_collections(1)
      [%Collection{}, ...]

  """
  def list_collections(user) do
    Collection
    |> where([t], t.user_id == ^user.id)
    |> Repo.all()
  end

  @doc """
  Gets a single collection.

  Raises `Ecto.NoResultsError` if the Collection does not exist.

  ## Examples

      iex> get_collection!(123, 1)
      %Collection{}

      iex> get_collection!(456, -1)
      ** (Ecto.NoResultsError)

  """
  def get_collection!(id, user), do: Repo.get_by!(Collection, id: id, user_id: user.id)

  @doc """
  Creates a collection.

  ## Examples

      iex> create_collection(%{field: value})
      {:ok, %Collection{}}

      iex> create_collection(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_collection(attrs \\ %{}) do
    %Collection{}
    |> Collection.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a collection.

  ## Examples

      iex> update_collection(collection, %{field: new_value})
      {:ok, %Collection{}}

      iex> update_collection(collection, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_collection(%Collection{} = collection, attrs) do
    collection
    |> Collection.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a collection.

  ## Examples

      iex> delete_collection(collection)
      {:ok, %Collection{}}

      iex> delete_collection(collection)
      {:error, %Ecto.Changeset{}}

  """
  def delete_collection(%Collection{} = collection) do
    Repo.delete(collection)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking collection changes.

  ## Examples

      iex> change_collection(collection)
      %Ecto.Changeset{data: %Collection{}}

  """
  def change_collection(%Collection{} = collection, attrs \\ %{}) do
    Collection.changeset(collection, attrs)
  end
end
