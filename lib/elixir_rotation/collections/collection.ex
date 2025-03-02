defmodule ElixirRotation.Collections.Collection do
  use Ecto.Schema
  import Ecto.Changeset

  schema "collections" do
    field :name, :string
    field :description, :string
    field :webhook, :string
    field :webhook_variable, :string
    field :schedule, :string
    field :algorithm, Ecto.Enum, values: [:random_one, :random_all_fit, :random_all], default: :random_one
    field :put_back, :boolean, default: false

    belongs_to :user, ElixirRotation.Accounts.User
    many_to_many :people, ElixirRotation.People.Person,
      join_through: "collections_people",
      on_replace: :delete
    many_to_many :tasks, ElixirRotation.Tasks.Task,
      join_through: "collections_tasks",
      on_replace: :delete
    has_many :matches, ElixirRotation.Matches.Match

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(collection, attrs) do
    collection
    |> cast(attrs, [:name, :description, :webhook, :schedule, :user_id, :algorithm, :put_back, :webhook_variable])
    |> validate_required([:name, :user_id, :algorithm, :put_back])
    |> validate_format(:webhook, ~r/^https?:\/\/[\w\-]+(\.[\w\-]+)+[#?\/\w\-]*$/)
    |> assoc_constraint(:user)
    |> cast_assoc(:people)
    |> cast_assoc(:tasks)
  end
end
