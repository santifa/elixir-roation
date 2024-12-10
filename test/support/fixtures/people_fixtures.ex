defmodule ElixirRotation.PeopleFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `ElixirRotation.People` context.
  """

  @doc """
  Generate a person.
  """
  def person_fixture(attrs \\ %{}) do
    {:ok, person} =
      attrs
      |> Enum.into(%{
        description: "some description",
        name: "some name"
      })
      |> ElixirRotation.People.create_person()

    person
  end
end
