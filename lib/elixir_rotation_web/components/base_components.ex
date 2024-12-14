defmodule ElixirRotationWeb.BaseComponents do
  use ElixirRotationWeb, :html

  attr :num, :integer, required: true

  def num_circle(assigns) do
    ~H"""
    <span class="inline-flex items-center justify-center w-3 h-3 p-3 ms-3 text-sm font-medium text-blue-800 bg-blue-100 rounded-full dark:bg-blue-900 dark:text-blue-300">
      {@num}
    </span>
    """
  end

  attr :items, :map, required: true
  attr :name, :string, required: true
  attr :nav, :string, required: true

  def list_head(assigns) do
    ~H"""
    <h2 class="mt-8 mb-2 text-md font-semibold">{@name}</h2>
    <ul class="mt-4 max-w-md space-y-1 list-inside">
      <li :for={item <- @items}>
        <a
          href={~p"/#{@nav}/#{item}"}
          class="font-medium text-blue-600 dark:text-blue-500 hover:underline"
        >
          {item.name}
        </a>
      </li>
    </ul>
    """
  end
end
