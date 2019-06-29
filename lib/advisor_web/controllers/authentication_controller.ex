defmodule AdvisorWeb.AuthenticationController do
  use AdvisorWeb, :controller
  plug Ueberauth

  def callback(%{assigns: %{ueberauth_auth: auth}} = conn, _params) do
    email = auth.info.email
    user = Advisor.People.find_by(email: email)

    proceed(user, conn, redirect_to: destination(conn))
  end

  def logout(conn, _params) do
    conn
    |> configure_session(drop: true)
    |> redirect(to: "/")
  end

  defp destination(conn) do
    conn
    |> fetch_session()
    |> get_session(:target) || "/"
  end

  defp proceed(nil, conn, _), do: conn |> redirect(to: "/")

  defp proceed(%{id: id}, conn, redirect_to: destination) do
    conn
    |> fetch_session()
    |> clear_session()
    |> put_session(:user, "#{id}")
    |> redirect(to: destination)
  end
end
