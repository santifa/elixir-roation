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

  attr :name, :string, required: true

  def subhead(assigns) do
    ~H"""
    <h2 class="mt-8 mb-2 text-md font-semibold">{@name}</h2>
    """
  end


  attr :title, :string, required: true
  attr :icon, :string, default: nil
  attr :nav, :string, required: true
  attr :items, :map, required: true

  def card(assigns) do
    ~H"""
    <div class="w-full max-w-md p-4 bg-white border border-gray-400/75 rounded-lg shadow sm:p-4 bg-gray-800 border-gray-700">
      <div class="flex items-center justify-between mb-4">
        <h5 class="text-m font-bold leading-none text-gray-900 underline underline-offset-8">
          {@title}
        </h5>
      </div>
      <div class="flow-root">
        <ul role="list" class="divide-y divide-gray-200 divide-gray-700">
          <li :for={item <- @items} class="py-3 sm:py-4">
            <div class="flex items-center">
              <div class="flex-shrink-0">
                <%= if not is_nil(@icon) do %>
                  <.icon name={@icon} class="flex-shrink-0 w-4 h-4" />
                <% end %>
              </div>
              <div class="flex-1 min-w-0 ms-4">
                <p class="text-sm font-medium text-gray-900 truncate">
                  {item.name}
                </p>
                <p class="text-sm text-gray-500 truncate dark:text-gray-400">
                  {item.description}
                </p>
              </div>
              <div class="inline-flex items-center text-base font-semibold text-gray-900">
                <.link href={~p"/#{@nav}/#{item}"} class="ml-1">
                  <.button>Show</.button>
                </.link>

                <.link href={~p"/#{@nav}/#{item}/edit"} class="ml-1">
                  <.button>Edit</.button>
                </.link>

                <.link
                  href={~p"/#{@nav}/#{item}"}
                  method="delete"
                  data-confirm="Are you sure?"
                  class="ml-1"
                >
                  <.button>Delete</.button>
                </.link>
              </div>
            </div>
          </li>

          <li class="py-3 sm:py-4">
            <p class="text-sm font-medium text-gray-900 truncate">
              <.link href={~p"/#{@nav}/new"}>
                <.button>New</.button>
              </.link>
            </p>
          </li>
        </ul>
      </div>
    </div>
    """
  end
end
