defmodule ProductManagerCoreWeb.SidebarComponent do
  use ProductManagerCoreWeb, :live_component

  attr :show, :boolean, default: false
  attr :current_user, :map, required: true
  attr :path, :string, default: ""
  slot :inner_block, required: true

  @impl true
  def render(assigns) do
    assigns =
      assign(assigns, :menu_items, [
        %{
          path: ~p"/providers",
          name: "Proveedores",
          icon: "hero-building-office-2",
          roles: ["root", "admin"]
        },
        %{path: ~p"/users", name: "Usuarios", icon: "hero-users", roles: ["root"]}
      ])
      |> assign(:logo, ~p"/images/logo.svg")
      |> assign(:list_roles_user, Enum.map(assigns.current_user.roles, fn rol -> rol.slug end))

    ~H"""
    <div>
      <%= if @current_user do %>
        <div
          class="relative z-40 md:hidden "
          phx-mounted={show_sidebar("sidebar-mobile", @show)}
          role="dialog"
          aria-modal="true"
          id="sidebar-mobile"
        >
          <div class="fixed inset-0 bg-gray-600 bg-opacity-75"></div>
          <div class="fixed inset-0 z-40 flex">
            <div class="relative flex w-full max-w-xs flex-1 flex-col bg-white pt-5 pb-4 dark:bg-neutral-900">
              <div class="absolute top-0 right-0 -mr-12 pt-2 ">
                <button
                  type="button"
                  phx-click={
                    JS.push("hide", target: @myself) |> hide_mobile_sidebar("sidebar-mobile")
                  }
                  phx-click-away={
                    JS.push("hide", target: @myself) |> hide_mobile_sidebar("sidebar-mobile")
                  }
                  phx-window-keydown={
                    JS.push("hide", target: @myself) |> hide_mobile_sidebar("sidebar-mobile")
                  }
                  phx-key="escape"
                  class="ml-1 flex h-10 w-10 items-center justify-center rounded-full focus:outline-none focus:ring-2 focus:ring-inset focus:ring-white"
                >
                  <span class="sr-only">Close sidebar</span>
                  <!-- Heroicon name: outline/x-mark -->
                  <.icon name="hero-x-mark" class="h-6 w-6 text-white" />
                </button>
              </div>

              <div class="flex flex-shrink-0 items-center px-4">
                <img class="h-8 w-auto" src={@logo} />
              </div>

              <div class="mt-5 h-0 flex-1 overflow-y-auto">
                <nav class="space-y-1 px-2">
                  <%= for item <- @menu_items  do %>
                    <%= if  has_access?(item.roles, @list_roles_user) do %>
                      <.active_link
                        current_url={@current_url}
                        navigate={item.path}
                        class="text-gray-900 group flex items-center px-2 py-2 text-base font-medium rounded-md dark:text-white dark:hover:bg-neutral-800"
                      >
                        <.icon
                          name={item.icon}
                          class="text-gray-500 mr-4 flex-shrink-0 h-6 w-6 dark:text-white"
                        />{item.name}
                      </.active_link>
                    <% end %>
                  <% end %>
                </nav>
              </div>
            </div>

            <div class="w-14 flex-shrink-0" aria-hidden="true">
              <!-- Dummy element to force sidebar to shrink to fit close icon -->
            </div>
          </div>
        </div>
        <div class="hidden md:fixed md:inset-y-0 md:flex md:w-64 md:flex-col">
          <!-- Sidebar component, swap this element with another sidebar if you like -->
          <div class="flex flex-grow flex-col overflow-y-auto border-r border-gray-200 bg-white pt-5 dark:bg-neutral-800 dark:border-neutral-900">
            <div class="flex flex-shrink-0 items-center px-4">
              <img class="h-8 w-auto" src={@logo} />
            </div>
            <div class="mt-5 flex flex-grow flex-col">
              <nav class="flex-1 space-y-1 px-2 pb-4">
                <%= for item <- @menu_items  |> IO.inspect() do %>
                  <%= if  has_access?(item.roles, @list_roles_user) do %>
                    <.active_link
                      current_url={@current_url}
                      navigate={item.path}
                      class="text-gray-900 group flex items-center px-2 py-2 text-sm font-medium rounded-md dark:text-white dark:hover:bg-neutral-900 hover:bg-gray-50"
                    >
                      <.icon
                        name={item.icon}
                        class="text-gray-500 mr-3 flex-shrink-0 h-6 w-6 dark:text-white"
                      />{item.name}
                    </.active_link>
                  <% end %>
                <% end %>
              </nav>
            </div>
          </div>
        </div>

        <div class="flex flex-1 flex-col md:pl-64">
          <div class="sticky top-0 z-10 flex h-16 flex-shrink-0 bg-white shadow  dark:bg-neutral-800">
            <button
              phx-click={
                JS.push("toggle", target: @myself) |> toggle_sidebar("sidebar-mobile", @show)
              }
              type="button"
              class="border-r border-gray-200 px-4 text-gray-500 focus:outline-none focus:ring-2 focus:ring-inset focus:ring-indigo-500 md:hidden dark:border-neutral-900"
            >
              <span class="sr-only">Abrir menu del sitio</span>
              <.icon name="hero-bars-3-bottom-left" class="h-6 w-6" />
            </button>
            <div class="flex flex-1 justify-end px-4">
              <div class="ml-4 flex items-center md:ml-6">

    <!-- Profile dropdown -->
                <div class="relative ml-3 ">
                  <.dropdown show={false} to="user_menu">
                    <:content>
                      <span class="sr-only">Abrir menu de usuario</span>
                      <div class="relative inline-flex items-center justify-center w-10 h-10 overflow-hidden bg-gray-100 rounded-full dark:bg-neutral-700">
                        <span class="font-medium text-gray-600 dark:text-gray-300">
                          {generate_avatar_initials(@current_user)}
                        </span>
                      </div>
                    </:content>

                    <.link
                      navigate={~p"/users/settings"}
                      class="block px-4 py-2 text-sm text-gray-700 dark:bg-neutral-700 dark:text-white"
                      role="menuitem"
                      tabindex="-1"
                      id="user-settings"
                    >
                      Configuraciones
                    </.link>
                    <.link
                      href={~p"/logout"}
                      method="delete"
                      class="block px-4 py-2 text-sm text-gray-700 dark:bg-neutral-700 dark:text-white"
                      role="menuitem"
                      tabindex="-1"
                      id="user-menu-item-2"
                    >
                      Salir
                    </.link>
                  </.dropdown>
                </div>
              </div>
            </div>
          </div>
          {render_slot(@inner_block)}
        </div>
      <% else %>
        {render_slot(@inner_block)}
      <% end %>
    </div>
    """
  end

  @impl true
  def handle_event("toggle", _, socket) do
    {:noreply, socket |> assign(:show, !socket.assigns.show)}
  end

  def handle_event("hide", _, socket) do
    {:noreply, socket |> assign(:show, false)}
  end

  def hide_mobile_sidebar(js \\ %JS{}, id) do
    js
    |> JS.add_class("hidden",
      to: "##{id}",
      transition: {"ease-in-out duration-300", "opacity-100", "opacity-100"}
    )
  end

  def show_mobile_sidebar(js \\ %JS{}, id) do
    js
    |> JS.remove_class("hidden",
      to: "##{id}",
      transition: {"ease-in-out duration-300", "opacity-0", "opacity-100"}
    )
  end

  def toggle_sidebar(js, id, show) do
    if show do
      hide_mobile_sidebar(js, id)
    else
      show_mobile_sidebar(js, id)
    end
  end

  def show_sidebar(id, show) do
    if show do
      show_mobile_sidebar(%JS{}, id)
    else
      hide_mobile_sidebar(%JS{}, id)
    end
  end
end
