defmodule ElixirRotation.Collections.Collection do
  use Ecto.Schema
  import Ecto.Changeset

  schema "collections" do
    field :name, :string
    field :description, :string
    field :webhook, :string
    field :match_interval, :string
    belongs_to :user, ElixirRotation.Accounts.User

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(collection, attrs) do
    collection
    |> cast(attrs, [:name, :description, :webhook, :match_interval, :user_id])
    |> validate_required([:name, :description, :webhook, :match_interval, :user_id])
    |> assoc_constraint(:user)
  end
end
