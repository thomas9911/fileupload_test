defmodule FileuploadTest.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      {Plug.Cowboy, scheme: :http, plug: FileuploadTest.Router, options: [port: 4001]}
    ]

    opts = [strategy: :one_for_one, name: FileuploadTest.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
