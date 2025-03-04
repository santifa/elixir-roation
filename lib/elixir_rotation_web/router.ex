defmodule ElixirRotationWeb.Router do
  alias ElixirRotationWeb.Plugs.Dashboard
  use ElixirRotationWeb, :router
  use Pow.Phoenix.Router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug Dashboard
    plug :put_root_layout, html: {ElixirRotationWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :protected do
    plug Pow.Plug.RequireAuthenticated,
      error_handler: ElixirRotationWeb.AuthErrorHandler
  end

  scope "/" do
    pipe_through :browser

    pow_routes()
  end

  scope "/", ElixirRotationWeb do
    pipe_through [:browser]

    get "/", PageController, :home
    get "/about", PageController, :about
    get "/contact", PageController, :contact
  end

  scope "/", ElixirRotationWeb do
    pipe_through [:browser, :protected]

    get "/dashboard", DashboardController, :index

    # Resource bundles
    resources "/tasks", TaskController, only: [:index, :create, :update, :delete]
    resources "/people", PersonController, only: [:index, :create, :update, :delete]

    resources "/collections", CollectionController,
      only: [:index, :create, :update, :delete, :show] do
      post "/run", CollectionController, :run
    end
  end

  # Other scopes may use custom stacks.
  # scope "/api", ElixirRotationWeb do
  #   pipe_through :api
  # end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:elixir_rotation, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: ElixirRotationWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
