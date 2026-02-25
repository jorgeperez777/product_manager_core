defmodule ProductManagerCore.Repo do
  use Ecto.Repo,
    otp_app: :product_manager_core,
    adapter: Ecto.Adapters.Postgres
end
