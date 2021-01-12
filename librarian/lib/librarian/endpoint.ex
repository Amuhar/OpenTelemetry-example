defmodule Librarian.Endpoint do
  @moduledoc false

  use Plug.Router

  plug(:match)

  plug(Plug.Parsers,
    parsers: [:json],
    pass: ["application/json"],
    json_decoder: Jason
  )

  plug(:dispatch)

  post("/", to: Librarian.Plug)

  match _ do
    send_resp(conn, 404, "")
  end
end
