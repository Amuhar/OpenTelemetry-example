defmodule Librarian.Plug do
  import Plug.Conn

  require OpenTelemetry.Tracer
  require OpenTelemetry.Span

  @spec init(any) :: any
  def init(opts), do: opts

  @spec call(Plug.Conn.t(), any()) :: Plug.Conn.t()
  def call(conn, _opts) do
    conn
    |> handle_call(conn.params)
    |> send_json_resp(conn)
  end

  defp handle_call(conn, %{"book" => book}) do
    ctx =
      conn
      |> Plug.Conn.get_req_header("traceparent")
      |> get_ctx()

    OpenTelemetry.Tracer.set_current_span(ctx)    

    OpenTelemetry.Tracer.with_span "request-book-span" do
      ctx = OpenTelemetry.Tracer.current_span_ctx()

      OpenTelemetry.Span.set_attributes(ctx, [
        {"method", conn.method},
        {"node", node()},
        {"url", Plug.Conn.request_url(conn)}
      ])

      book_availability(book, ctx)
    end
  end

  defp send_json_resp(result, conn) do
    body =
      case result do
        true -> Jason.encode!(%{result: :book_found})
        false -> Jason.encode!(%{result: :book_not_found})
      end

    conn
    |> put_resp_header("content-type", "application/json")
    |> send_resp(200, body)
  end

  defp get_ctx([]), do: :undefined

  defp get_ctx([traceparent | _]) do
    :otel_propagator_http_w3c.decode(traceparent)
  end

  defp book_availability(book, ctx) do
    :librarian
    |> Application.get_env(:library_node)
    |> :rpc.call(Library, :available?, [book, ctx])
  end
end
