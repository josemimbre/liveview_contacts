defmodule LiveviewContacts.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      LiveviewContactsWeb.Telemetry,
      LiveviewContacts.Repo,
      {DNSCluster, query: Application.get_env(:liveview_contacts, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: LiveviewContacts.PubSub},
      # Start a worker by calling: LiveviewContacts.Worker.start_link(arg)
      # {LiveviewContacts.Worker, arg},
      # Start to serve requests, typically the last entry
      LiveviewContactsWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: LiveviewContacts.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    LiveviewContactsWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
