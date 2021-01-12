defmodule Reader do
  require OpenTelemetry.Tracer
  require OpenTelemetry.Span

  @readers ["Alice"]

  def request_book(reader, book) do
    OpenTelemetry.Tracer.with_span "request-book-span" do
      ctx = OpenTelemetry.Tracer.current_span_ctx()

      OpenTelemetry.Span.set_attributes(ctx, [
        {"node", node()},
        {"client", reader},
        {"book", book}
      ])
      
      do_request_book(reader, book)
    end
  end

  defp do_request_book(reader, book) when reader in @readers do
    case Reader.Sender.send(book) do
      {:ok, %Tesla.Env{body: %{"result" => result}}} -> {:ok, result}
      error -> 
        OpenTelemetry.Tracer.set_status("Internal error")
        {:error, error}
    end
  end

  defp do_request_book(reader, _book) do
    {:error, "Reader #{reader} isn't in reader list."}
  end
end