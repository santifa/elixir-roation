defmodule ElixirRotation.Collections.Collection do
  use Ecto.Schema
  import Ecto.Changeset

  schema "collections" do
    field :name, :string
    field :description, :string
    field :webhook, :string
    field :match_interval, :string
    belongs_to :user, ElixirRotation.Accounts.User
    many_to_many :people, ElixirRotation.People.Person,
      join_through: "collections_people",
      on_replace: :delete
    many_to_many :tasks, ElixirRotation.Tasks.Task,
      join_through: "collections_tasks",
      on_replace: :delete

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(collection, attrs) do
    collection
    |> cast(attrs, [:name, :description, :webhook, :match_interval, :user_id])
    |> validate_required([:name, :description, :webhook, :match_interval, :user_id])
    |> assoc_constraint(:user)
    # TODO: Fix as this should be working
    #|> cast_assoc(:people, required: true)
  end
end
