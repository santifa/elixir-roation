defmodule ElixirRotationWeb.CollectionControllerTest do
  use ElixirRotationWeb.ConnCase

  import ElixirRotation.CollectionsFixtures

  @create_attrs %{name: "some name", description: "some description", webhook: "some webhook", match_interval: "some match_interval"}
  @update_attrs %{name: "some updated name", description: "some updated description", webhook: "some updated webhook", match_interval: "some updated match_interval"}
  @invalid_attrs %{name: nil, description: nil, webhook: nil, match_interval: nil}

  describe "index" do
    test "lists all collections", %{conn: conn} do
      conn = get(conn, ~p"/collections")
      assert html_response(conn, 200) =~ "Listing Collections"
    end
  end

  describe "new collection" do
    test "renders form", %{conn: conn} do
      conn = get(conn, ~p"/collections/new")
      assert html_response(conn, 200) =~ "New Collection"
    end
  end

  describe "create collection" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, ~p"/collections", collection: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == ~p"/collections/#{id}"

      conn = get(conn, ~p"/collections/#{id}")
      assert html_response(conn, 200) =~ "Collection #{id}"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, ~p"/collections", collection: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Collection"
    end
  end

  describe "edit collection" do
    setup [:create_collection]

    test "renders form for editing chosen collection", %{conn: conn, collection: collection} do
      conn = get(conn, ~p"/collections/#{collection}/edit")
      assert html_response(conn, 200) =~ "Edit Collection"
    end
  end

  describe "update collection" do
    setup [:create_collection]

    test "redirects when data is valid", %{conn: conn, collection: collection} do
      conn = put(conn, ~p"/collections/#{collection}", collection: @update_attrs)
      assert redirected_to(conn) == ~p"/collections/#{collection}"

      conn = get(conn, ~p"/collections/#{collection}")
      assert html_response(conn, 200) =~ "some updated name"
    end

    test "renders errors when data is invalid", %{conn: conn, collection: collection} do
      conn = put(conn, ~p"/collections/#{collection}", collection: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit Collection"
    end
  end

  describe "delete collection" do
    setup [:create_collection]

    test "deletes chosen collection", %{conn: conn, collection: collection} do
      conn = delete(conn, ~p"/collections/#{collection}")
      assert redirected_to(conn) == ~p"/collections"

      assert_error_sent 404, fn ->
        get(conn, ~p"/collections/#{collection}")
      end
    end
  end

  defp create_collection(_) do
    collection = collection_fixture()
    %{collection: collection}
  end
end
