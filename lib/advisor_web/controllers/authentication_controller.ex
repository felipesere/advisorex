defmodule AdvisorWeb.AuthenticationController do
  use AdvisorWeb, :controller
  alias Advisor.People


  def login(conn, _params) do
    render(conn, "login.html", error_message: nil)
  end

  def submit(conn, %{"user" => user_params}) do
    %{"email" => email, "password" => password} = user_params

    if user = People.get_user_by_email_and_password(email, password) do
      proceed(user, conn, redirect_to: destination(conn))
    else
      # In order to prevent user enumeration attacks, don't disclose whether the email is registered.
      render(conn, "login.html", error_message: "Invalid email or password")
    end
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
