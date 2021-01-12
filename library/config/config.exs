# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
use Mix.Config

config :opentelemetry,
       :processors,
       otel_batch_processor: %{
         exporter:
           {:opentelemetry_zipkin,
            %{
              address:
                to_charlist(
                  System.get_env("ZIPKIN_ADDRESS", "http://localhost:9411/api/v2/spans")
                ),
              local_endpoint: %{service_name: "library"}
            }}
       }
