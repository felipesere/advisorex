defmodule AdvisorWeb.DashboardPage do
  use AdvisorWeb, :controller
  alias Advisor.Core.{Dashboard, Person, People}
  alias AdvisorWeb.Authentication.User

  plug AdvisorWeb.Authentication.Gatekeeper

  def index(conn, _params) do
    user = User.of(conn)
    dashboard = Dashboard.for_user(user)

    render(conn, "index.html",
      user: user,
      dashboard: dashboard,
      update_user: Person.changeset(user)
    )
  end

  def settings(conn, %{"person" => person}) do
      conn
      |> User.extract
      |> Person.changeset(person)
      |> People.update()
      |> back_to_dashboard(conn)
  end

  def back_to_dashboard({:ok, _}, conn), do: redirect_with_flash(conn, :info, "Settings updated!")

  def back_to_dashboard({:error, _}, conn), do: redirect_with_flash(conn, :error, "Sorry, something went wrong")

  def redirect_with_flash(conn, status, message) do
    conn
    |> put_flash(status, message)
    |> redirect(to: "/dashboard")
  end
end
