defmodule ElixirRotationWeb.UserAuth do
  use ElixirRotationWeb, :html

  attr :user, :map, required: true

  def auth_links(assigns) do
    ~H"""
    <div>
      <%= if is_nil(@user) do %>
        <.link href={~p"/registration/new"} class="hover:text-zinc-700">Registrieren</.link>
        <.link href={~p"/session/new"} class="hover:text-zinc-700 rounded-lg bg-zinc-100 px-2 py-1">Einloggen</.link>
      <% else %>
        <.link href={~p"/registration/edit"} class="hover:text-zinc-700 "><%= @user.email %></.link>
        <.link href={~p"/session"} method="delete" class="hover:text-zinc-700 rounded-lg bg-zinc-100 px-2 py-1">Abmelden</.link>
      <% end %>
    </div>
    """
  end
end
