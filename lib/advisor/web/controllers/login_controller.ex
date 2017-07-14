defmodule Advisor.Web.LoginController do
  use Advisor.Web, :controller
  alias Advisor.Core.People
  alias Advisor.Web.Authentication.Password

  def index(conn, %{"email" => email, "password" => pw, "submit" => "dashboard"}) do
    login(conn, as: email, with: pw, redirect_to: "/dashboard")
  end

  def index(conn, %{"email" => email, "password" => pw, "submit" => "advice"}) do
    login(conn, as: email, with: pw, redirect_to: "/request")
  end

  def index(conn, %{"email" => email, "password" => pw, "submit" => "redirect"}) do
    target = conn.cookies["target"] || "/"

    login(conn, as: email, with: pw, redirect_to: target)
  end

  def login(conn, [as: email, with: password,  redirect_to: destination]) do
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

  def redirect({conn, nil}), do: redirect(conn, to: "/request")
  def redirect({conn, destination}), do: redirect(conn, to: destination)
end
