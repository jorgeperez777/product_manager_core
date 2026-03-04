defmodule ProductManagerCoreWeb.ProviderLive.Index do
  use ProductManagerCoreWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, index_params: nil) |> assign(:current_page, :dashboard_home)}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(%{assigns: assigns} = socket, :index, _params) do
    socket
    |> assign(:page_title, "Dasboard Principal")
  end
end
