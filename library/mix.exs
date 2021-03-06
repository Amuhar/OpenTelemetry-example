defmodule Library.MixProject do
  use Mix.Project

  def project do
    [
      app: :library,
      version: "0.1.0",
      elixir: "~> 1.10",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {Library.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:opentelemetry_api, "~> 0.5.0"},
      {:opentelemetry, "~> 0.5.0"},
      {:opentelemetry_zipkin, "~> 0.4.0"}
    ]
  end
end
