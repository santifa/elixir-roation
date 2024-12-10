defmodule ElixirRotationWeb.PersonControllerTest do
  use ElixirRotationWeb.ConnCase

  import ElixirRotation.PeopleFixtures

  @create_attrs %{name: "some name", description: "some description"}
  @update_attrs %{name: "some updated name", description: "some updated description"}
  @invalid_attrs %{name: nil, description: nil}

  describe "index" do
    test "lists all people", %{conn: conn} do
      conn = get(conn, ~p"/people")
      assert html_response(conn, 200) =~ "Listing People"
    end
  end

  describe "new person" do
    test "renders form", %{conn: conn} do
      conn = get(conn, ~p"/people/new")
      assert html_response(conn, 200) =~ "New Person"
    end
  end

  describe "create person" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, ~p"/people", person: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == ~p"/people/#{id}"

      conn = get(conn, ~p"/people/#{id}")
      assert html_response(conn, 200) =~ "Person #{id}"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, ~p"/people", person: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Person"
    end
  end

  describe "edit person" do
    setup [:create_person]

    test "renders form for editing chosen person", %{conn: conn, person: person} do
      conn = get(conn, ~p"/people/#{person}/edit")
      assert html_response(conn, 200) =~ "Edit Person"
    end
  end

  describe "update person" do
    setup [:create_person]

    test "redirects when data is valid", %{conn: conn, person: person} do
      conn = put(conn, ~p"/people/#{person}", person: @update_attrs)
      assert redirected_to(conn) == ~p"/people/#{person}"

      conn = get(conn, ~p"/people/#{person}")
      assert html_response(conn, 200) =~ "some updated name"
    end

    test "renders errors when data is invalid", %{conn: conn, person: person} do
      conn = put(conn, ~p"/people/#{person}", person: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit Person"
    end
  end

  describe "delete person" do
    setup [:create_person]

    test "deletes chosen person", %{conn: conn, person: person} do
      conn = delete(conn, ~p"/people/#{person}")
      assert redirected_to(conn) == ~p"/people"

      assert_error_sent 404, fn ->
        get(conn, ~p"/people/#{person}")
      end
    end
  end

  defp create_person(_) do
    person = person_fixture()
    %{person: person}
  end
end
