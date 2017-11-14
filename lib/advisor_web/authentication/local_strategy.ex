defmodule Local.Strategy do
  use Ueberauth.Strategy

  alias Ueberauth.Auth.Info
  alias Ueberauth.Strategy.Helpers
  alias Plug.Conn.Query

  def handle_request!(conn) do
    path = Helpers.callback_path(conn)
    query = conn.query_string
    redirect!(conn, "#{path}?#{query}")
  end

  def info(conn) do
    params = Query.decode(conn.query_string)
    if params["user"] == "ron" do
      %Info{
        urls: %{website: "8thlight.com"},
        email: "rswanson@8thlight.com",
        name: "Ron Swanson"
      }
    else
      %Info{
        urls: %{website: "8thlight.com"},
        email: "lknope@8thlight.com",
        name: "Leslie Knope"
      }
    end
  end
end
