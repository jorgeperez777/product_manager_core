defmodule ProductManagerCoreWeb.ProviderController do
  alias ProductManagerCore.Catalog
  alias ProductManagerCore.Validators
  use ProductManagerCoreWeb, :controller
  action_fallback ProductManagerCoreWeb.FallbackController

  def get_providers(conn, params) do
    params = params |> Map.put("active", true)

    with {:ok, params} <- Validators.Validator.provider(params),
         {:ok, providers} =
           {:ok, Catalog.list_providers(params)} do
      render(conn, :index, providers: providers)
    else
      {:error, error} ->
        conn
        |> render(:error, error: error)
    end
  end
end
