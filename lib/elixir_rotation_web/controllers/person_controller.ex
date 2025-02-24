defmodule ElixirRotationWeb.PersonController do
  use ElixirRotationWeb, :controller

  alias ElixirRotation.People
  alias ElixirRotation.People.Person

  def get_prepared_people(user) do
    people = People.list_people(user)

    people =
      Enum.map(people, fn p ->
        ids = People.get_collection_ids(p.id)
        Map.put(p, :collections, ids)
      end)

    Enum.map(people, fn p ->
      changeset = People.change_person(p)
      Map.put(p, :changeset, changeset)
    end)
  end

  def index(conn, _params) do
    user = Pow.Plug.current_user(conn)
    people = get_prepared_people(user)
    changeset = People.change_person(%Person{})
    render(conn, :index, people: people, changeset: changeset)
  end

  def create(conn, %{"person" => person_params}) do
    user = Pow.Plug.current_user(conn)
    person_params = Map.put(person_params, "user_id", user.id)

    case People.create_person(person_params) do
      {:ok, _person} ->
        conn
        |> put_flash(:info, "Person created successfully.")
        |> redirect(to: ~p"/people")

      {:error, %Ecto.Changeset{} = changeset} ->
        people = get_prepared_people(user)
        new_changeset = People.change_person(%Person{})
        [{field, {msg, _}} | _] = changeset.errors

        conn
        |> put_flash(:error, "Failed to create person #{field} with #{msg}")
        |> render(:index, people: people, changeset: new_changeset)
    end
  end

  def update(conn, %{"id" => id, "person" => person_params}) do
    user = Pow.Plug.current_user(conn)
    person = People.get_person!(id, user)

    case People.update_person(person, person_params) do
      {:ok, _person} ->
        conn
        |> put_flash(:info, "Person updated successfully.")
        |> redirect(to: ~p"/people")

      {:error, %Ecto.Changeset{} = changeset} ->
        people = People.list_people(user)

        people =
          Enum.map(people, fn p ->
            ids = People.get_collection_ids(p.id)
            Map.put(p, :collections, ids)
          end)

        people =
          Enum.map(people, fn p ->
            if p.id == person.id do
              Map.put(p, :changeset, changeset)
            else
              changeset = People.change_person(p)
              Map.put(p, :changeset, changeset)
            end
          end)

        changeset = People.change_person(%Person{})
        [{field, {msg, _}} | _] = changeset.errors

        conn
        |> put_flash(:error, "Failed to change person #{person.id} #{field} with #{msg}")
        |> render(:index, people: people, changeset: changeset)
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
