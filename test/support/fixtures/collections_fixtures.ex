defmodule ElixirRotation.CollectionsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `ElixirRotation.Collections` context.
  """

  @doc """
  Generate a collection.
  """
  def collection_fixture(attrs \\ %{}) do
    {:ok, collection} =
      attrs
      |> Enum.into(%{
        description: "some description",
        schedule: "some schedule",
        name: "some name",
        webhook: "some webhook"
      })
      |> ElixirRotation.Collections.create_collection()

    collection
  end
end
