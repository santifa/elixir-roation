defmodule ElixirRotationWeb.PageController do
  use ElixirRotationWeb, :controller


  def home(conn, _params) do
    # Redirect a user to its dashboard on login or registration.
    user = Pow.Plug.current_user(conn)

    case is_nil(user) do
      true -> render(conn, :home)
      false -> redirect(conn, to: ~p"/dashboard")
    end

  end
end
