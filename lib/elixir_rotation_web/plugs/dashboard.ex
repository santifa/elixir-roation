defmodule ElixirRotationWeb.Plugs.Dashboard do
  alias ElixirRotation.People
  alias ElixirRotation.Tasks
  alias ElixirRotation.Collections
  import Plug.Conn

  def init(default), do: default

  def call(conn, _options) do
    case Pow.Plug.current_user(conn) do
      nil -> conn
      user ->
        num_colls = length(Collections.list_collections(user))
        num_tasks = length(Tasks.list_tasks(user))
        num_people = length(People.list_people(user))
        assign(conn, :dashboard_nums,
          %{collections: num_colls,
            tasks: num_tasks,
            people: num_people})
    end
  end

end
