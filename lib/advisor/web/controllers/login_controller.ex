defmodule Advisor.Web.LoginController do
  use Advisor.Web, :controller
  alias Advisor.Web.Authentication.User

  plug Advisor.Web.Authentication.Gatekeeper, redirect: false

  def index(conn, params) do
    login(conn, params, redirect_to: destination(conn, params))
  end

  def destination(conn, params) do
    case Map.fetch!(params, "submit") do
      "dashboard" -> "/dashboard"
      "advice" -> "/request"
      "redirect" -> conn.cookies["target"] || "/"
    end
  end

  def login(conn, %{"email" => email, "password" => password}, destination) do
    user = User.logged_in_with(email, password)
    proceed(conn, user, destination)
  end

  def login(conn, _, destination) do
    user = User.of(conn)
    proceed(conn, user, destination)
  end

  def proceed(conn, nil, _), do: redirect(conn, to: "/")
  def proceed(conn, %{id: id}, [redirect_to: destination]) do
    conn
    |> put_resp_cookie("user", "#{id}")
    |> put_resp_cookie("target", "deleted")
    |> redirect(to: destination)
  end
end
