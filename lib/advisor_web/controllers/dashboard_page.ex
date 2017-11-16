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
    User.of(conn)
    |> Person.changeset(person)
    |> People.update()

    redirect(conn, to: "/dashboard")
  end
end
