defmodule ProductManagerCoreWeb.RequreRole do
  import Plug.Conn

  def init(required_roles), do: required_roles

  def call(conn, required_roles) do
    user = conn.assigns.current_user

    cond do
      is_nil(user) ->
        conn
        |> send_resp(401, "Unauthorized")

      has_role?(user, required_roles) ->
        conn

      true ->
        conn
        |> send_resp(403, "Forbidden")
        |> halt()
    end
  end

  defp has_role?(user, required_roles) do
    user.roles
    |> Enum.map(& &1.slug)
    |> Enum.any?(&(&1 in required_roles))
  end


end
