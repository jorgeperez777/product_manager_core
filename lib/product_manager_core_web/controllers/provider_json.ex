defmodule ProductManagerCoreWeb.ProviderJSON do
  alias ProductManagerCore.Catalog.Provider
   def index(%{providers: providers}) do
    %{data: for(provider <- providers, do: data(provider))}
  end

  def show(%{provider: provider}) do
    %{data: data(provider)}
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

  def data(%Provider{} = provider) do
    %{
      id: provider.id,
      name: provider.name,
      slug: provider.slug,
      active: provider.active,
      url_image: provider.url_image,
      status: provider.status
    }
  end
end
