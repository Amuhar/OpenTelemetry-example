defmodule Reader.Traceparent do
  @moduledoc """
  Плаг устанавливает заголовок traceparent, если информация о контексте найдена
  """

  @behaviour Tesla.Middleware

  require OpenTelemetry.Tracer

  @impl Tesla.Middleware
  def call(env, next, _opts) do
    env =
      case generate_header() do
        :undefined -> env
        header -> Tesla.put_headers(env, [{"traceparent", header}])
      end

    Tesla.run(env, next)
  end

  defp generate_header() do
    case OpenTelemetry.Tracer.current_span_ctx() do
      :undefined -> :undefined
      ctx -> :otel_propagator_http_w3c.encode(ctx)
    end
  end
end
