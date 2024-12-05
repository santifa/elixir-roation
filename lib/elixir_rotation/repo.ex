defmodule ElixirRotation.Repo do
  use Ecto.Repo,
    otp_app: :elixir_rotation,
    adapter: Ecto.Adapters.SQLite3
end
