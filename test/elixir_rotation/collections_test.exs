defmodule ElixirRotation.CollectionsTest do
  use ElixirRotation.DataCase

  alias ElixirRotation.Collections

  describe "collections" do
    alias ElixirRotation.Collections.Collection

    import ElixirRotation.CollectionsFixtures

    @invalid_attrs %{name: nil, description: nil, webhook: nil, match_interval: nil}

    test "list_collections/0 returns all collections" do
      collection = collection_fixture()
      assert Collections.list_collections() == [collection]
    end

    test "get_collection!/1 returns the collection with given id" do
      collection = collection_fixture()
      assert Collections.get_collection!(collection.id) == collection
    end

    test "create_collection/1 with valid data creates a collection" do
      valid_attrs = %{name: "some name", description: "some description", webhook: "some webhook", match_interval: "some match_interval"}

      assert {:ok, %Collection{} = collection} = Collections.create_collection(valid_attrs)
      assert collection.name == "some name"
      assert collection.description == "some description"
      assert collection.webhook == "some webhook"
      assert collection.match_interval == "some match_interval"
    end

    test "create_collection/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Collections.create_collection(@invalid_attrs)
    end

    test "update_collection/2 with valid data updates the collection" do
      collection = collection_fixture()
      update_attrs = %{name: "some updated name", description: "some updated description", webhook: "some updated webhook", match_interval: "some updated match_interval"}

      assert {:ok, %Collection{} = collection} = Collections.update_collection(collection, update_attrs)
      assert collection.name == "some updated name"
      assert collection.description == "some updated description"
      assert collection.webhook == "some updated webhook"
      assert collection.match_interval == "some updated match_interval"
    end

    test "update_collection/2 with invalid data returns error changeset" do
      collection = collection_fixture()
      assert {:error, %Ecto.Changeset{}} = Collections.update_collection(collection, @invalid_attrs)
      assert collection == Collections.get_collection!(collection.id)
    end

    test "delete_collection/1 deletes the collection" do
      collection = collection_fixture()
      assert {:ok, %Collection{}} = Collections.delete_collection(collection)
      assert_raise Ecto.NoResultsError, fn -> Collections.get_collection!(collection.id) end
    end

    test "change_collection/1 returns a collection changeset" do
      collection = collection_fixture()
      assert %Ecto.Changeset{} = Collections.change_collection(collection)
    end
  end
end
