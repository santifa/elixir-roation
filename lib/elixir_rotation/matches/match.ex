defmodule ElixirRotation.Matches.Match do
  use Ecto.Schema
  import Ecto.Changeset

  schema "matches" do
    field :random_type, :string

    belongs_to :user, ElixirRotation.Accounts.User
    belongs_to :collection, ElixirRotation.Collections.Collection

    many_to_many :people, ElixirRotation.People.Person,
      join_through: "matches_people",
      on_replace: :delete
    many_to_many :tasks, ElixirRotation.Tasks.Task,
      join_through: "matches_tasks",
      on_replace: :delete

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(match, attrs) do
    match
    |> cast(attrs, [:random_type, :user_id, :collection_id])
    |> validate_required([:random_type, :user_id, :collection_id])
    |> assoc_constraint(:user)
    |> assoc_constraint(:collection)
    |> cast_assoc(:people)
    |> cast_assoc(:tasks)
  end
end
