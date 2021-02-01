defmodule FileuploadTest.Router do
  use Plug.Router

  plug(CORSPlug)

  # settings mulitpart https://hexdocs.pm/plug/Plug.Parsers.MULTIPART.html

  plug(Plug.Parsers,
    # accepts file sizes till `length` bytes
    parsers: [:urlencoded, {:multipart, length: 20_000_000}, :json, Absinthe.Plug.Parser],
    pass: ["*/*"],
    json_decoder: Jason
  )

  plug(Absinthe.Upload)

  plug(Plug.Static, at: "/absinthe_graphiql", from: "priv/static/absinthe_graphiql")
  plug(Plug.Static, at: "/images", from: "priv/static/images")

  forward("/graphql",
    to: Absinthe.Plug,
    init_opts: [schema: FileuploadTest.Schema]
  )

  forward("/graphiql",
    to: Absinthe.Plug.GraphiQL,
    init_opts: [schema: FileuploadTest.Schema, interface: :playground]
  )

  forward("/rest", to: FileuploadTest.Rest)

  plug(:match)
  plug(:dispatch)

  get "/hello" do
    send_resp(conn, 200, "world")
  end

  match _ do
    send_resp(conn, 404, "oops")
  end
end
