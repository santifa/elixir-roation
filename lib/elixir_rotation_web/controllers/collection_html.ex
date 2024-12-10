defmodule ElixirRotationWeb.CollectionHTML do
  use ElixirRotationWeb, :html

  embed_templates "collection_html/*"

  @doc """
  Renders a collection form.
  """
  attr :changeset, Ecto.Changeset, required: true
  attr :action, :string, required: true

  def collection_form(assigns)
end
