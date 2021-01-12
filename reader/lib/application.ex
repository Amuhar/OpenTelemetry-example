defmodule Reader.Application do
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = []

    _ = OpenTelemetry.register_application_tracer(:reader)

    opts = [strategy: :one_for_one, name: Reader.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
