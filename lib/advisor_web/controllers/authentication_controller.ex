defmodule AdvisorWeb.AuthenticationController do
  use AdvisorWeb, :controller

  alias Advisor.Core.LoginUser

  plug Ueberauth

  def callback(%{assigns: %{ueberauth_auth: auth}} = conn, _params) do
    if auth.info.urls[:website] == "8thlight.com" do
      target = destination(conn)

      auth
      |> LoginUser.find_or_create()
      |> proceed(conn, redirect_to: target)
    else
      # Flash?
      conn |> redirect(to: "/")
    end
  end

  def destination(conn) do
    conn
    |> fetch_session()
    |> get_session(:target) || "/"
  end

  # Flash?
  def proceed(nil, conn,  _), do: conn |> redirect(to: "/")
  def proceed(%{id: id}, conn, [redirect_to: destination]) do
    conn
    |> fetch_session()
    |> clear_session()
    |> put_session(:user, "#{id}")
    |> redirect(to: destination)
  end

  def logout(conn, _params) do
    conn
    |> configure_session(drop: true)
    |> redirect(to: "/")
  end
end
