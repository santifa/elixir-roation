defmodule ElixirRotationWeb.PersonController do
  use ElixirRotationWeb, :controller

  alias ElixirRotation.People
  alias ElixirRotation.People.Person

  def index(conn, _params) do
    user = Pow.Plug.current_user(conn)
    people = People.list_people(user)
    render(conn, :index, people: people)
  end

  def new(conn, _params) do
    changeset = People.change_person(%Person{})
    render(conn, :new, changeset: changeset)
  end

  def create(conn, %{"person" => person_params}) do
    user = Pow.Plug.current_user(conn)
    person_params = Map.put(person_params, "user_id", user.id)

    case People.create_person(person_params) do
      {:ok, person} ->
        conn
        |> put_flash(:info, "Person created successfully.")
        |> redirect(to: ~p"/people/#{person}")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :new, changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    user = Pow.Plug.current_user(conn)
    person = People.get_person!(id, user)
    render(conn, :show, person: person)
  end

  def edit(conn, %{"id" => id}) do
    user = Pow.Plug.current_user(conn)
    person = People.get_person!(id, user)
    changeset = People.change_person(person)
    render(conn, :edit, person: person, changeset: changeset)
  end

  def update(conn, %{"id" => id, "person" => person_params}) do
    user = Pow.Plug.current_user(conn)
    person = People.get_person!(id, user)

    case People.update_person(person, person_params) do
      {:ok, person} ->
        conn
        |> put_flash(:info, "Person updated successfully.")
        |> redirect(to: ~p"/people/#{person}")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :edit, person: person, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    user = Pow.Plug.current_user(conn)
    person = People.get_person!(id, user)
    {:ok, _person} = People.delete_person(person)

    conn
    |> put_flash(:info, "Person deleted successfully.")
    |> redirect(to: ~p"/people")
  end
end
