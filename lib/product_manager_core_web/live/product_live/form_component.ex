defmodule ProductManagerCoreWeb.ProductLive.FormComponent do
  use ProductManagerCoreWeb, :live_component

  alias ProductManagerCore.Catalog

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        {@title}
        <:subtitle>Use this form to manage product records in your database.</:subtitle>
      </.header>

      <.simple_form
        for={@form}
        id="product-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input field={@form[:name]} type="text" label="Name" required />
        <.input field={@form[:description]} type="text" label="Description" />
        <.input field={@form[:stock]} type="number" label="Stock" />
        <.input field={@form[:amount]} type="number" label="Amount" step="any" />
        <.input field={@form[:active]} type="checkbox" label="Active" />
        <.input
          field={@form[:provider_id]}
          type="select"
          prompt="Seleciona una proveedor"
          options={Enum.map(@list_providers, fn t -> {t.name, t.id} end)}
          class="mt-1 block w-full rounded-md border-gray-300 shadow-sm focus:border-indigo-500 focus:ring-indigo-500 sm:text-sm"
        />

        <%!-- <.input
          field={@form[:category_ids]}
          type="select"
          multiple={true}
          label="Categorías"
          options={Enum.map(@list_categories, &{&1.name, &1.id})}
        /> --%>

        <div class="flex flex-col gap-2">
          <label class="font-medium">Categorías</label>
          <%= for category <- @list_categories do %>
            <label class="flex items-center gap-2 cursor-pointer">
              <input
                type="checkbox"
                name="product[category_ids][]"
                value={category.id}
                checked={category.id in selected_category_ids(@form)}
              />
              {category.name}
            </label>
          <% end %>
          <input type="hidden" name="product[category_ids][]" value="" />
        </div>
        <.input field={@form[:url_image]} type="text" label="Url image" />
        <.input field={@form[:slug]} type="hidden" />

        <:actions>
          <.button phx-disable-with="Saving...">Save Product</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{product: product} = assigns, socket) do
    providers = Catalog.list_providers(%{active: true})
    categories = Catalog.list_categories(%{active: true})
    changeset = Catalog.change_product(product)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:list_providers, providers)
     |> assign(:list_categories, categories)
     |> assign(:form, to_form(changeset))}
  end

  @impl true
  def handle_event("validate", %{"product" => product_params}, socket) do
    changeset = Catalog.change_product(socket.assigns.product, product_params)
    {:noreply, assign(socket, form: to_form(changeset, action: :validate))}
  end

  def handle_event("save", %{"product" => product_params}, socket) do
    save_product(socket, socket.assigns.action, product_params)
  end

  defp save_product(socket, :edit, product_params) do
    category_ids = Map.get(product_params, "category_ids", [])
    product_params = Map.put(product_params, "category_ids", category_ids)

    case Catalog.update_product(socket.assigns.product, product_params) do
      {:ok, product} ->
        notify_parent({:saved, product})

        {:noreply,
         socket
         |> put_flash(:info, "Product updated successfully")
         |> push_navigate(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp save_product(socket, :new, product_params) do
    category_ids = Map.get(product_params, "category_ids", [])
    product_params = Map.put(product_params, "category_ids", category_ids)

    case Catalog.create_product(product_params) do
      {:ok, product} ->
        notify_parent({:saved, product})

        {:noreply,
         socket
         |> put_flash(:info, "Product created successfully")
         |> push_navigate(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})

  defp selected_category_ids(form) do
    case form[:category_ids].value do
      nil ->
        categories = form[:category_ids].form.data.categories

        case categories do
          %Ecto.Association.NotLoaded{} -> []
          nil -> []
          list -> Enum.map(list, & &1.id)
        end

      value ->
        value
        |> List.wrap()
        |> Enum.flat_map(fn
          %{id: id} ->
            [id]

          "" ->
            []

          nil ->
            []

          id ->
            case Integer.parse(to_string(id)) do
              {int, _} -> [int]
              :error -> []
            end
        end)
    end
  end
end
