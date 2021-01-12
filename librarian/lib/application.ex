defmodule Librarian.Application do
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      Plug.Cowboy.child_spec(
        scheme: :http,
        plug: Librarian.Endpoint,
        options: [port: 4001]
      )
    ]

    _ = OpenTelemetry.register_application_tracer(:librarian)

    opts = [strategy: :one_for_one, name: Librarian.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
