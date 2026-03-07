defmodule ProductManagerCoreWeb.ProviderLive.FormComponent do
  use ProductManagerCoreWeb, :live_component

  alias ProductManagerCore.Catalog

  @impl true
  def render(assigns) do
    ~H"""
    <div class="dark:bg-neutral-800">
      <.header>
        {@title}
        <:subtitle>Use this form to manage provider records in your database.</:subtitle>
      </.header>

      <.simple_form
        for={@form}
        id="provider-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input field={@form[:name]} type="text" label="Name" />
        <.input field={@form[:active]} type="checkbox" label="Active" />
        <.input field={@form[:telephone]} type="text" label="Telephone" />
        <.input field={@form[:location]} type="text" label="Location" />
        <.input field={@form[:url_contact]} type="text" label="Url contact" />
        <.input field={@form[:email]} type="text" label="Email" />
        <.input field={@form[:url_image]} type="text" label="Url image" />
        <.input field={@form[:slug]} type="hidden" />

        <:actions>
          <.button phx-disable-with="Saving...">Save Provider</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{provider: provider} = assigns, socket) do
    {:ok,
     socket
     |> assign(assigns)
     |> assign_new(:form, fn ->
       to_form(Catalog.change_provider(provider))
     end)}
  end

  @impl true
  def handle_event("validate", %{"provider" => provider_params}, socket) do
    changeset = Catalog.change_provider(socket.assigns.provider, provider_params)
    {:noreply, assign(socket, form: to_form(changeset, action: :validate))}
  end

  def handle_event("save", %{"provider" => provider_params}, socket) do
    save_provider(socket, socket.assigns.action, provider_params)
  end

  defp save_provider(socket, :edit, provider_params) do
    case Catalog.update_provider(socket.assigns.provider, provider_params) do
      {:ok, provider} ->
        notify_parent({:saved, provider})

        {:noreply,
         socket
         |> put_flash(:info, "Provider updated successfully")
         |> push_navigate(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp save_provider(socket, :new, provider_params) do
    case Catalog.create_provider(provider_params) do
      {:ok, provider} ->
        notify_parent({:saved, provider})

        {:noreply,
         socket
         |> put_flash(:info, "Provider created successfully")
         |> push_navigate(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})
end
