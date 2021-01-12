defmodule Reader.Sender do
  use Tesla, only: [:post]

  plug(Tesla.Middleware.JSON)
  plug(Tesla.Middleware.Headers, [{"content-type", "application/json"}])
  plug(Tesla.Middleware.Logger)
  plug(Reader.Traceparent)

  @spec send(String.t()) :: {:error, any} | {:ok, Tesla.Env.t()}
  def send(book) do
    post(url() <> ":" <> port(), %{book: book})
  end

  defp url() do
    Application.get_env(:reader, __MODULE__)[:librarian_url]
  end

  defp port() do
    Application.get_env(:reader, __MODULE__)[:librarian_port]
  end
end
