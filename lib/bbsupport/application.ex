defmodule Bbsupport.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      BbsupportWeb.Telemetry,
      Bbsupport.Repo,
      {DNSCluster, query: Application.get_env(:bbsupport, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: Bbsupport.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: Bbsupport.Finch},
      # Start a worker by calling: Bbsupport.Worker.start_link(arg)
      # {Bbsupport.Worker, arg},
      # Start to serve requests, typically the last entry
      BbsupportWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Bbsupport.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    BbsupportWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
