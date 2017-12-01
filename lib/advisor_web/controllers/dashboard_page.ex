defmodule AdvisorWeb.DashboardPage do
  use AdvisorWeb, :controller
  alias Advisor.Core.{Dashboard, Person, People}
  alias AdvisorWeb.Authentication.User

  plug AdvisorWeb.Authentication.Gatekeeper

  def index(conn, _params) do
    user = User.of(conn)
    dashboard = Dashboard.for_user(user)

    render conn, "index.html", user: user,
                               dashboard: dashboard,
                               update_user: Person.changeset(user)

  end

  def settings(conn, %{"person" => person}) do
    changeset = User.of(conn)
                |> Person.changeset(person)

    case People.update(changeset) do
      {:ok, _} ->
        redirect_with_flash(conn, :info, "Settings updated!")
      {:error, _} ->
        redirect_with_flash(conn, :error, "Sorry, something went wrong")
    end
  end

  def redirect_with_flash(conn, status, message) do
    conn
    |> put_flash(status, message)
    |> redirect(to: "/dashboard")
  end
end
