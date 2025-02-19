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
  slot :link, required: false

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
              <div
                :for={link <- @link}
                class="inline-flex items-center text-base font-semibold text-gray-900"
              >
                {render_slot(link)}
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

  attr :target, :string, required: true
  attr :title, :string, required: true

  def modal_edit(assigns) do
    ~H"""
    <div
      id="{@target}"
      tabindex="-1"
      aria-hidden="true"
      class="hidden overflow-y-auto overflow-x-hidden fixed top-0 right-0 left-0 z-50 justify-center items-center w-full md:inset-0 h-[calc(100%-1rem)] max-h-full"
    >
      <div class="relative p-4 w-full max-w-md max-h-full">
        <!-- Modal content -->
        <div class="relative bg-white rounded-lg shadow dark:bg-gray-700">
          <!-- Modal header -->
          <div class="flex items-center justify-between p-4 md:p-5 border-b rounded-t dark:border-gray-600">
            <h3 class="text-xl font-semibold text-gray-900 dark:text-white">
              Sign in to our platform
            </h3>
            <button
              type="button"
              class="end-2.5 text-gray-400 bg-transparent hover:bg-gray-200 hover:text-gray-900 rounded-lg text-sm w-8 h-8 ms-auto inline-flex justify-center items-center dark:hover:bg-gray-600 dark:hover:text-white"
              data-modal-hide="authentication-modal"
            >
              <svg
                class="w-3 h-3"
                aria-hidden="true"
                xmlns="http://www.w3.org/2000/svg"
                fill="none"
                viewBox="0 0 14 14"
              >
                <path
                  stroke="currentColor"
                  stroke-linecap="round"
                  stroke-linejoin="round"
                  stroke-width="2"
                  d="m1 1 6 6m0 0 6 6M7 7l6-6M7 7l-6 6"
                />
              </svg>
              <span class="sr-only">Close modal</span>
            </button>
          </div>
          <!-- Modal body -->
          <div class="p-4 md:p-5"></div>
        </div>
      </div>
    </div>
    """
  end
end
