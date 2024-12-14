defmodule ElixirRotationWeb.DashboardController do
  alias ElixirRotation.Tasks
  alias ElixirRotation.People
  alias ElixirRotation.Collections
  use ElixirRotationWeb, :controller

  def index(conn, _params) do
    user = Pow.Plug.current_user(conn)

    render(conn, :index, current_user: user)
  end
end
