defmodule AdvisorWeb.LoginController do
  use AdvisorWeb, :controller
  alias AdvisorWeb.Authentication.User

  # TODO: Verify this against the Gatekeeper
  plug AdvisorWeb.Authentication.Gatekeeper, redirect: false

  def index(conn, params) do
    login(params, conn, redirect_to: destination(conn, params))
  end

  def destination(conn, params) do
    case Map.fetch!(params, "submit") do
      "dashboard" -> "/dashboard"
      "advice" -> "/request"
      "redirect" -> conn.cookies["target"] || "/"
    end
  end

  def login(%{"email" => email, "password" => password}, conn, destination) do
    User.logged_in_with(email, password)
    |> proceed(conn, destination)
  end

  def login(_, conn, destination) do
    conn
    |> User.extract()
    |> proceed(conn, destination)
  end

  def proceed(nil, conn , _), do: redirect(conn, to: "/")
  def proceed(%{id: id}, conn, [redirect_to: destination]) do
    conn
    |> put_resp_cookie("user", "#{id}")
    |> put_resp_cookie("target", "deleted")
    |> redirect(to: destination)
  end

  def logout(conn, _params) do
    conn
    |> put_resp_cookie("user", "deleted")
    |> redirect(to: "/")
  end
end
