defmodule ProductManagerCoreWeb.FallbackController do
  use ProductManagerCoreWeb, :controller

  def call(conn, {:error, %Ecto.Changeset{} = changeset}) do
    conn
    |> put_status(:unprocessable_entity)
    |> put_view(json: ProductManagerCoreWeb.ChangesetJson)
    |> render(:error, changeset: changeset)
  end

  def call(conn, {:error, :not_found}) do
    conn
    |> put_status(:not_found)
    |> put_view(html: ProductManagerCoreWeb.ErrorHTML, json: ProductManagerCoreWeb.ErrorJSON)
    |> render(:"404")
  end
end
