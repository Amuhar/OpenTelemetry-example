defmodule Library do
  require OpenTelemetry.Tracer

  @catalog ["Fanity fair", "It", "1984"]

  @spec available?(String.t(), any()) :: boolean()
  def available?(book, parent_span \\ :undefined) do
    OpenTelemetry.Tracer.set_current_span(parent_span)

    OpenTelemetry.Tracer.with_span "available-book-span" do
      OpenTelemetry.Tracer.current_span_ctx()
      |> OpenTelemetry.Span.set_attribute("node", node())

      book in @catalog
    end
  end
end
