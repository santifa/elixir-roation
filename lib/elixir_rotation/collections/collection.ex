defmodule ElixirRotation.Collections.Collection do
  use Ecto.Schema
  import Ecto.Changeset

  schema "collections" do
    field :name, :string
    field :description, :string
    field :webhook, :string
    field :match_interval, :string
    field :user_id, :id

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(collection, attrs) do
    collection
    |> cast(attrs, [:name, :description, :webhook, :match_interval])
    |> validate_required([:name, :description, :webhook, :match_interval])
  end
end
