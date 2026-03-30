defmodule ProductManagerCoreWeb.CategoryController do
  alias ProductManagerCore.Catalog
  alias ProductManagerCore.Validators
  use ProductManagerCoreWeb, :controller
  action_fallback ProductManagerCoreWeb.FallbackController

  def get_categories(conn, params) do
    params = params |> Map.put("active", true)

    with {:ok, params} <- Validators.Validator.category(params),
         {:ok, categories} =
           {:ok, Catalog.list_categories(params)} do
      render(conn, :index, categories: categories)
    else
      {:error, error} ->
        conn
        |> render(:error, error: error)
    end
  end
end
