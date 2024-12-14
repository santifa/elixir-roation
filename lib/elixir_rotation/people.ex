defmodule ElixirRotation.People do
  @moduledoc """
  The People context.
  """

  import Ecto.Query, warn: false
  alias ElixirRotation.Collections.Collection
  alias ElixirRotation.Repo

  alias ElixirRotation.People.Person

  @doc """
  Returns the list of people.

  ## Examples

      iex> list_people(1)
      [%Person{}, ...]

  """
  def list_people(user) do
    Person
    |> where([t], t.user_id == ^user.id)
    |> Repo.all()
  end


  @doc """
  Gets a single person.

  Raises `Ecto.NoResultsError` if the Person does not exist.

  ## Examples

      iex> get_person!(123, 1)
      %Person{}

      iex> get_person!(456, -1)
      ** (Ecto.NoResultsError)

  """
  def get_person!(id, user), do: Repo.get_by!(Person, id: id, user_id: user.id)

  @doc """
  Creates a person.

  ## Examples

      iex> create_person(%{field: value})
      {:ok, %Person{}}

      iex> create_person(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_person(attrs \\ %{}) do
    %Person{}
    |> Person.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a person.

  ## Examples

      iex> update_person(person, %{field: new_value})
      {:ok, %Person{}}

      iex> update_person(person, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_person(%Person{} = person, attrs) do
    person
    |> Person.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a person.

  ## Examples

      iex> delete_person(person)
      {:ok, %Person{}}

      iex> delete_person(person)
      {:error, %Ecto.Changeset{}}

  """
  def delete_person(%Person{} = person) do
    Repo.delete(person)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking person changes.

  ## Examples

      iex> change_person(person)
      %Ecto.Changeset{data: %Person{}}

  """
  def change_person(%Person{} = person, attrs \\ %{}) do
    Person.changeset(person, attrs)
  end

  def get_collection_ids(person_id) do
    query =
      from colls in "collections_people",
      where: [person_id: ^person_id],
      select: colls.collection_id
    ids = Repo.all(query)

    Enum.map(ids, fn id -> Repo.get!(Collection, id) end)
  end
end
