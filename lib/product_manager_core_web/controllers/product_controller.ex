defmodule ProductManagerCoreWeb.ProductController do
  alias ProductManagerCore.Catalog
  alias ProductManagerCore.Validators
  use ProductManagerCoreWeb, :controller
  action_fallback ProductManagerCoreWeb.FallbackController

  def options(conn, _params) do
    conn
    |> put_resp_header("access-control-allow-origin", "http://localhost:5173")
    |> put_resp_header("access-control-allow-methods", "GET, POST, PUT, DELETE, OPTIONS")
    |> put_resp_header("access-control-allow-headers", "content-type, authorization")
    |> send_resp(200, "")
  end

  def get_products(conn, params) do
    params = params |> Map.put("active", true)

    with {:ok, params} <- Validators.Validator.product(params),
         {:ok, products} =
           {:ok, Catalog.list_products(params)} do
      render(conn, :index, products: products)
    else
      {:error, error} ->
        conn
        |> render(:error, error: error)
    end
  end

  def get_product_by_slug(conn, params) do

    with {:ok, params} <- Validators.Validator.product_by_slug(params),
         {:ok, product} =
           {:ok, Catalog.get_product_by_slug!(params.slug)} do
      render(conn, :show, product: product)
    else
      {:error, error} ->
        conn
        |> render(:error, error: error)
    end
  end
end
