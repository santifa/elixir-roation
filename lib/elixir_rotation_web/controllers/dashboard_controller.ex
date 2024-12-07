defmodule ElixirRotationWeb.DashboardController do
  use ElixirRotationWeb, :controller

  def index(conn, _params) do
    render(conn, :index, current_user: Pow.Plug.current_user(conn))
  end
end
