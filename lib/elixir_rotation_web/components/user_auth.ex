defmodule ElixirRotationWeb.UserAuth do
  use ElixirRotationWeb, :html

  attr :user, :map, required: true

  def user_nav(assigns) do
    ~H"""
    <%= if is_nil(@user) do %>

    <!-- Small screen burger menu for login -->
      <button
        id="user-small-button"
        type="button"
        aria-expanded="hidden"
        data-dropdown-toggle="user-small"
        class="inline-flex items-center p-2 text-sm text-gray-500 rounded-lg sm:hidden hover:bg-gray-100 focus:outline-none focus:ring-2 focus:ring-gray-200 dark:text-gray-400 dark:hover:bg-gray-700 dark:focus:ring-gray-600"
      >
        <span class="sr-only">Open sidebar</span>
        <svg
          class="w-6 h-6"
          aria-hidden="true"
          fill="currentColor"
          viewBox="0 0 20 20"
          xmlns="http://www.w3.org/2000/svg"
        >
          <path
            clip-rule="evenodd"
            fill-rule="evenodd"
            d="M2 4.75A.75.75 0 012.75 4h14.5a.75.75 0 010 1.5H2.75A.75.75 0 012 4.75zm0 10.5a.75.75 0 01.75-.75h7.5a.75.75 0 010 1.5h-7.5a.75.75 0 01-.75-.75zM2 10a.75.75 0 01.75-.75h14.5a.75.75 0 010 1.5H2.75A.75.75 0 012 10z"
          >
          </path>
        </svg>
      </button>
      <div
        id="user-small"
        class="z-50 hidden my-4 text-base list-none bg-white divide-y divide-gray-100 rounded shadow dark:bg-gray-700 dark:divide-gray-600"
      >
        <ul class="py-1" role="none">
          <li>
            <.link
              href={~p"/registration/new"}
              class="block px-4 py-2 text-sm text-gray-700 hover:bg-gray-100 dark:text-gray-300 dark:hover:bg-gray-600 dark:hover:text-white"
            >
              <span class="flex-1 ms-3 whitespace-nowrap">Sign Up</span>
            </.link>
          </li>
          <li>
            <.link
              href={~p"/session/new"}
              class="block px-4 py-2 text-sm text-gray-700 hover:bg-gray-100 dark:text-gray-300 dark:hover:bg-gray-600 dark:hover:text-white"
            >
              <span class="flex-1 ms-3 whitespace-nowrap">Sign In</span>
            </.link>
          </li>
        </ul>
      </div>

    <!-- Show sing-up and sign-in if user is not logged in -->
      <div class="flex items-center mx-2 hidden lg:block md:block xl:block xl2:block">
        <.link
          href={~p"/registration/new"}
          class="p-2 text-gray-900 rounded-lg dark:text-white hover:bg-gray-100 dark:hover:bg-gray-700"
        >
          <span class="flex-1 ms-3 whitespace-nowrap">Sign Up</span>
        </.link>
        <.link
          href={~p"/session/new"}
          class="p-2 text-gray-900 rounded-lg dark:text-white hover:bg-gray-100 dark:hover:bg-gray-700"
        >
          <span class="flex-1 ms-3 whitespace-nowrap">Sign In</span>
        </.link>
      </div>
    <% else %>

    <!-- Show user icon and user menu if user is logged in -->
      <div class="mx-2">
        <button
          id="dropdown-user-button"
          type="button"
          aria-expanded="hidden"
          data-dropdown-toggle="dropdown-user"
          class="inline-flex text-sm bg-gray-800 rounded-full focus:ring-4 focus:ring-gray-300 dark:focus:ring-gray-600"
        >
          <span class="sr-only">Open user menu</span>
          <.icon name="hero-user-circle-solid" class="w-8 h-8 text-white" />
        </button>
      </div>

      <div
        id="dropdown-user"
        class="z-50 hidden my-4 text-base list-none bg-white divide-y divide-gray-100 rounded shadow dark:bg-gray-700 dark:divide-gray-600"
      >
        <div class="px-4 py-3" role="none">
          <%= if Map.has_key?(@user, :name) do %>
            <p class="text-sm text-gray-900 dark:text-white" role="none">
              {@user.name}
            </p>
          <% end %>
          <p class="text-sm font-medium text-gray-900 truncate dark:text-gray-300" role="none">
            {@user.email}
          </p>
        </div>

        <ul class="py-1" role="none" aria-labelledby="dropdown-user-button">
          <li>
            <.link
              href={~p"/"}
              class="block px-4 py-2 text-sm text-gray-700 hover:bg-gray-100 dark:text-gray-300 dark:hover:bg-gray-600 dark:hover:text-white"
              role="menuitem"
            >
              Dashboard
            </.link>
          </li>
          <li>
            <.link
              href={~p"/registration/edit"}
              class="block px-4 py-2 text-sm text-gray-700 hover:bg-gray-100 dark:text-gray-300 dark:hover:bg-gray-600 dark:hover:text-white"
              role="menuitem"
            >
              Settings
            </.link>
          </li>
          <li>
            <.link
              href={~p"/session"}
              method="delete"
              class="block px-4 py-2 text-sm text-gray-700 hover:bg-gray-100 dark:text-gray-300 dark:hover:bg-gray-600 dark:hover:text-white"
              role="menuitem"
            >
              Sign out
            </.link>
          </li>
        </ul>
      </div>
    <% end %>
    """
  end
end
