defmodule ElixirRotation.Matches do
  @moduledoc """
  The Matches context.
  """

  import Ecto.Query, warn: false
  alias ElixirRotation.Repo
  alias ElixirRotation.Matches.Match

  @doc """
  Returns the list of matches.

  ## Examples

      iex> list_matches()
      [%Match{}, ...]

  """
  def list_user_matches(user) do
    Match
    |> where([t], t.user_id == ^user.id)
    Repo.all(Match)
  end

  @doc """
  Returns the list of matches which belong to a certain collection.
  """
  def list_collection_matches(user, collection) do
    Match
    |> where([m], m.user_id == ^user.id)
    |> where([m], m.collection_id == ^collection.id)
    |> Repo.all()
    |> Repo.preload([:people, :tasks])
    |> Enum.with_index()
  end

  def list_collection_matches(collection) do
    Match
    |> where([m], m.collection_id == ^collection.id)
    |> Repo.all()
    |> Repo.preload([:people, :tasks])
  end

  @doc """
  Gets a single match.

  Raises `Ecto.NoResultsError` if the Match does not exist.

  ## Examples

      iex> get_match!(123)
      %Match{}

      iex> get_match!(456)
      ** (Ecto.NoResultsError)

  """
  def get_match!(id, user), do: Repo.get!(Match, id: id, user_id: user.id)

  @doc """
  Creates a match.

  ## Examples

      iex> create_match(%{field: value})
      {:ok, %Match{}}

      iex> create_match(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_match(attrs \\ %{}, tasks, people) do
    %Match{}
    |> Match.changeset(attrs)
    |> Ecto.Changeset.put_assoc(:people, people)
    |> Ecto.Changeset.put_assoc(:tasks, tasks)
    |> Repo.insert()
  end


  @doc """
  Updates a match.

  ## Examples

      iex> update_match(match, %{field: new_value})
      {:ok, %Match{}}

      iex> update_match(match, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_match(%Match{} = match, attrs) do
    match
    |> Match.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a match.

  ## Examples

      iex> delete_match(match)
      {:ok, %Match{}}

      iex> delete_match(match)
      {:error, %Ecto.Changeset{}}

  """
  def delete_match(%Match{} = match) do
    Repo.delete(match)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking match changes.

  ## Examples

      iex> change_match(match)
      %Ecto.Changeset{data: %Match{}}

  """
  def change_match(%Match{} = match, attrs \\ %{}) do
    Match.changeset(match, attrs)
  end
end
