defmodule Advisor.Web.Authentication.Gatekeeper do
  import Plug.Conn
  alias Advisor.Core.People
  alias Advisor.Core.Person

  def init(opts), do: opts

  def call(conn, _params) do
    conn
    |> user_id
    |> People.find_by_id
    |> assign(conn)
  end

  def user_id(conn) do
    conn = fetch_cookies(conn)
    conn.req_cookies["user"]
  end

  def assign(%Person{} = user, conn) do
    assign(conn, :user, user)
  end
  def assign(_, conn) do
    conn
    |> redirect_to_login
  end

  def redirect_to_login(conn) do
    conn
    |> preserve_original_destination
    |> Phoenix.Controller.redirect(to: "/")
    |> halt()
  end

  defp preserve_original_destination(conn) do
    conn
    |> put_resp_cookie("target", conn.request_path)
  end
end