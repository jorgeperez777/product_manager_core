defmodule ProductManagerCoreWeb.ProductJSON do
  alias ProductManagerCoreWeb.ProviderJSON
  alias ProductManagerCoreWeb.CategoryJSON
  alias ProductManagerCore.Catalog.Product

  def index(%{products: products}) do
    %{data: for(product <- products, do: data(product))}
  end

  def show(%{product: product}) do
    %{data: data(product)}
  end

  def translate_errors(changeset) do
    Ecto.Changeset.traverse_errors(changeset, &translate_error/1)
  end

  def translate_error({msg, opts}) do
    if count = opts[:count] do
      Gettext.dngettext(PulseWeb.Gettext, "errors", msg, msg, count, opts)
    else
      Gettext.dgettext(PulseWeb.Gettext, "errors", msg, opts)
    end
  end

  def render("error.json", %{changeset: changeset}) do
    %{errors: translate_errors(changeset)}
  end

  def render("404.html", _assigns) do
    "Page not found"
  end

  def render("500.html", _assigns) do
    "Internal server error"
  end

  def render("invalid_params.json", %{error: error}) when is_map(error) do
    error
  end

  def render("invalid_params.json", %{error: error}) do
    %{error: error}
  end

  # In case no render clause matches or no
  # template is found, let's render it as 500
  def template_not_found(_template, assigns) do
    render("500.html", assigns)
  end

  def error(%{error: error}) when is_map(error) do
    error
  end

  def error(%{error: error}) do
    %{error: error}
  end

  def data(%Product{} = product) do
    if Ecto.assoc_loaded?(product.categories) && Ecto.assoc_loaded?(product.provider) do
      %{
        id: product.id,
        name: product.name,
        slug: product.slug,
        price: product.amount,
        active: product.active,
        status_stock: product.status_stock,
        url_image: product.url_image,
        status: product.status,
        stock: product.stock,
        description: product.description,
        provider: ProviderJSON.data(product.provider),
        categories: for(category <- product.categories, do: CategoryJSON.data(category))
      }
    else
      %{
        id: product.id,
        name: product.name,
        slug: product.slug,
        price: product.amount,
        active: product.active,
        status_stock: product.status_stock,
        url_image: product.url_image,
        status: product.status,
        stock: product.stock,
        description: product.description
      }
    end
  end
end
