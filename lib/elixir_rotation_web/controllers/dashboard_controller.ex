defmodule ElixirRotationWeb.DashboardController do
  use ElixirRotationWeb, :controller

  def index(conn, _params) do
    user = Pow.Plug.current_user(conn)

    render(conn, :index, current_user: user)
  end
end
