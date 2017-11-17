defmodule Local.Strategy do
  use Ueberauth.Strategy

  alias Ueberauth.Auth.Info
  alias Ueberauth.Strategy.Helpers
  alias Plug.Conn.Query
  alias Advisor.Core.People

  def handle_request!(conn) do
    path = Helpers.callback_path(conn)
    query = conn.query_string
    redirect!(conn, "#{path}?#{query}")
  end

  def info(conn) do
    params = Query.decode(conn.query_string)
    user = People.find_by(email: params["email"])

    %Info{
      urls: %{website: "8thlight.com"},
      email: user.email,
      name: user.name
    }
  end
end
