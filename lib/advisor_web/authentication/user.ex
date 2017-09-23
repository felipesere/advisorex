defmodule AdvisorWeb.Authentication.User do
  alias Advisor.Core.People
  alias AdvisorWeb.Authentication.Password

  def of(conn) do
    conn.assigns[:user]
  end

  def found_in(conn), do: of(conn)
  def extract(conn), do: of(conn)

  def logged_in_with(email, password) do
    user =  People.find_by(email: email)
    password_match = Password.matches?(password)

    case {user, password_match} do
      {_, false} -> nil
      {user, true} -> user
    end
  end
end
