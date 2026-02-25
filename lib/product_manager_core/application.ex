defmodule ProductManagerCore.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      ProductManagerCoreWeb.Telemetry,
      ProductManagerCore.Repo,
      {DNSCluster, query: Application.get_env(:product_manager_core, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: ProductManagerCore.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: ProductManagerCore.Finch},
      # Start a worker by calling: ProductManagerCore.Worker.start_link(arg)
      # {ProductManagerCore.Worker, arg},
      # Start to serve requests, typically the last entry
      ProductManagerCoreWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: ProductManagerCore.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    ProductManagerCoreWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
