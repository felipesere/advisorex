defmodule Advisor.Web.LoginController do
  use Advisor.Web, :controller
  alias Advisor.Core.People

  def index(conn, %{"email" => email, "dashboard" => _nothing}) do
    login(conn, as: email, redirect_to: "/dashboard")
  end

  def index(conn, %{"email" => email, "request" => _nothing}) do
    target = conn.cookies["target"] || "/request"

    login(conn, as: email, redirect_to: target)
  end

  def login(conn, [as: email, redirect_to: destination]) do
    user = People.find_by(email: email)

    if user do
      conn
      |> put_resp_cookie("user", "#{user.id}")
      |> redirect(to: destination)
    else
      conn
      |> redirect(to: "/")
    end
  end

  def look_for_redirect(conn) do
    {conn, conn.cookies["target"]}
  end

  def redirect({conn, nil}), do: redirect(conn, to: "/request")
  def redirect({conn, destination}), do: redirect(conn, to: destination)
end
