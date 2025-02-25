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
    <h2 class="mt-4 text-md font-semibold">{@name}</h2>
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

  attr :id, :string, required: true
  attr :title, :string, required: true
  attr :icon, :string, required: true

  slot :inner_block, doc: "inner form block"

  def modal_edit(assigns) do
    ~H"""
    <!-- Modal toggle -->
    <button
      data-modal-target={"edit-#{@id}"}
      data-modal-toggle={"edit-#{@id}"}
      class="block text-white bg-blue-700 hover:bg-blue-800 focus:ring-2 focus:outline-none focus:ring-blue-300 font-medium rounded-lg text-sm px-2 py-2 text-center dark:bg-blue-600 dark:hover:bg-blue-700 dark:focus:ring-blue-800"
      type="button"
    >
      <.icon name={@icon} class="h-4 w-4" />
    </button>

    <!-- Main modal -->
    <div
      id={"edit-#{@id}"}
      tabindex="-1"
      aria-hidden="true"
      class="hidden overflow-y-auto overflow-x-hidden fixed top-0 right-0 left-0 z-50 justify-center items-center w-full md:inset-0 h-[calc(100%-1rem)] max-h-full"
    >
      <div class="relative p-4 w-full max-w-md max-h-full">
        <!-- Modal content -->
        <div class="relative bg-white rounded-lg shadow-sm dark:bg-gray-700">
          <!-- Modal header -->
          <div class="flex items-center justify-between p-4 md:p-5 border-b rounded-t dark:border-gray-600 border-gray-200">
            <h3 class="text-lg font-semibold text-gray-900 dark:text-white">
              {@title}
            </h3>
            <button
              type="button"
              class="text-gray-400 bg-transparent hover:bg-gray-200 hover:text-gray-900 rounded-lg text-sm w-8 h-8 ms-auto inline-flex justify-center items-center dark:hover:bg-gray-600 dark:hover:text-white"
              data-modal-toggle={"edit-#{@id}"}
            >
              <.icon name="hero-x-mark-solid" class="h-8 w-8" />
              <span class="sr-only">Close modal</span>
            </button>
          </div>

    <!-- Modal body -->
          {render_slot(@inner_block)}

        </div>
      </div>
    </div>
    """
  end

  attr :title, :string, required: true
  attr :id, :string, required: true
  attr :href, :string, required: true

  def delete_modal(assigns) do
    ~H"""
    <button
      data-modal-target={"delete-#{@id}"}
      data-modal-toggle={"delete-#{@id}"}
      type="button"
      class="block text-white bg-blue-700 hover:bg-blue-800 focus:ring-2 focus:outline-none focus:ring-blue-300 font-medium rounded-lg text-sm px-2 py-2 text-center dark:bg-blue-600 dark:hover:bg-blue-700 dark:focus:ring-blue-800"
    >
      <.icon name="hero-trash-solid" class="h-4 w-4" />
    </button>

    <div
      id={"delete-#{@id}"}
      tabindex="-1"
      class="hidden overflow-y-auto overflow-x-hidden fixed top-0 right-0 left-0 z-50 justify-center items-center w-full md:inset-0 h-[calc(100%-1rem)] max-h-full"
    >
      <div class="relative p-4 w-full max-w-md max-h-full">
        <div class="relative bg-white rounded-lg shadow-sm dark:bg-gray-700">
          <button
            type="button"
            class="absolute top-3 end-2.5 text-gray-400 bg-transparent hover:bg-gray-200 hover:text-gray-900 rounded-lg text-sm w-8 h-8 ms-auto inline-flex justify-center items-center dark:hover:bg-gray-600 dark:hover:text-white"
            data-modal-hide={"delete-#{@id}"}
          >
            <.icon name="hero-x-mark-solid" class="h-8 w-8" />

            <span class="sr-only">Close modal</span>
          </button>
          <div class="p-4 md:p-5 text-center">
            <h3 class="mb-5 text-lg font-normal text-gray-500 dark:text-gray-400">
              Are you sure you want to delete {@title}?
            </h3>

            <button
              data-modal-hide={"delete-#{@id}"}
              type="button"
              class="text-white bg-red-600 hover:bg-red-800 focus:ring-4 focus:outline-none focus:ring-red-300 dark:focus:ring-red-800 font-medium rounded-lg text-sm inline-flex items-center px-5 py-2.5 text-center"
            >
              <.link method="delete" href={@href}>Yes</.link>
            </button>
            <button
              data-modal-hide={"delete-#{@id}"}
              type="button"
              class="py-2.5 px-5 ms-3 text-sm font-medium text-gray-900 focus:outline-none bg-white rounded-lg border border-gray-200 hover:bg-gray-100 hover:text-blue-700 focus:z-10 focus:ring-4 focus:ring-gray-100 dark:focus:ring-gray-700 dark:bg-gray-800 dark:text-gray-400 dark:border-gray-600 dark:hover:text-white dark:hover:bg-gray-700"
            >
              No
            </button>
          </div>
        </div>
      </div>
    </div>
    """
  end
end
