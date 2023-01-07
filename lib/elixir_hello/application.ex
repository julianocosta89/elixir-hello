defmodule ElixirHello.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    OpentelemetryPhoenix.setup()
    children = [
      # Start the Telemetry supervisor
      ElixirHelloWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: ElixirHello.PubSub},
      # Start the Endpoint (http/https)
      ElixirHelloWeb.Endpoint
      # Start a worker by calling: ElixirHello.Worker.start_link(arg)
      # {ElixirHello.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: ElixirHello.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    ElixirHelloWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
