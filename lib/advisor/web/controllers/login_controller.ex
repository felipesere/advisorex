defmodule Advisor.Web.LoginController do
  use Advisor.Web, :controller
  alias Advisor.Core.People
  alias Advisor.Web.Authentication.Password

  def index(conn, %{"submit" => "dashboard"} = params) do
    login(conn, params, redirect_to: "/dashboard")
  end

  def index(conn, %{"submit" => "advice"} = params) do
    login(conn, params, redirect_to: "/request")
  end

  def index(conn, %{"submit" => "redirect"} = params) do
    target = conn.cookies["target"] || "/"

    login(conn, params, redirect_to: target)
  end

  def login(conn, %{"email" => email, "password" => password}, [redirect_to: destination]) do
    user = People.find_by(email: email)

    if user && Password.matches?(password) do
      conn
      |> put_resp_cookie("user", "#{user.id}")
      |> put_resp_cookie("target", "deleted")
      |> redirect(to: destination)
    else
      conn
      |> redirect(to: "/")
    end
  end
end
