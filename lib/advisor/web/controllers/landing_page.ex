defmodule Advisor.Web.LandingPage do
  use Advisor.Web, :controller

  def index(conn, _params) do
    render conn, "index.html", button: "Ask for advice",
                               target: target(conn),
                               message: false
  end

  def target(%Plug.Conn{} = conn), do: target(conn.cookies["target"])
  def target(nil), do: false
  def target("deleted"), do: false
  def target(target) when is_binary(target), do: target
end
