defmodule Advisor.Web.LandingPage do
  use Advisor.Web, :controller
  alias Advisor.Web.Authentication.User

  plug  Advisor.Web.Authentication.Gatekeeper, redirect: false

  def index(conn, _params) do
    data = case User.of(conn) do
      nil -> [title: "Advisor", logged_in: false]
      %{name: name} -> [title: "Hello #{name}!", logged_in: true]
    end
    render conn, "index.html", Keyword.merge(data, target: target(conn))
  end

  def target(%Plug.Conn{} = conn), do: target(conn.cookies["target"])
  def target(nil), do: false
  def target("deleted"), do: false
  def target(target) when is_binary(target), do: target
end
