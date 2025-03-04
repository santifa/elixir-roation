defmodule ElixirRotation.Tasks.Task do
  use Ecto.Schema
  import Ecto.Changeset

  schema "tasks" do
    field :name, :string
    field :description, :string
    belongs_to :user, ElixirRotation.Accounts.User

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(task, attrs) do
    task
    |> cast(attrs, [:name, :description, :user_id])
    |> validate_required([:name, :user_id])
    |> assoc_constraint(:user)
  end
end
