defmodule ElixirRotationWeb.DashboardHTML do
  @moduledoc """
  This module contains pages rendered by DashboardController.

  See the `dashboard_html` directory for all templates available.
  """
  use ElixirRotationWeb, :html

  embed_templates "dashboard_html/*"
end
