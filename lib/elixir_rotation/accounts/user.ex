defmodule ElixirRotation.Accounts.User do
  use Ecto.Schema
  use Pow.Ecto.Schema

  schema "users" do
    pow_user_fields()
    field :name, :string

    has_many :tasks, ElixirRotation.Tasks.Task
    has_many :people, ElixirRotation.People.Person
    has_many :collections, ElixirRotation.Collections.Collection

    timestamps()
  end
end
