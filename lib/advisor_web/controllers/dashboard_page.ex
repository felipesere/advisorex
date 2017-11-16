defmodule AdvisorWeb.DashboardPage do
  use AdvisorWeb, :controller
  alias Advisor.Core.{Dashboard, Person, People}
  alias AdvisorWeb.Authentication.User

  plug AdvisorWeb.Authentication.Gatekeeper

  def index(conn, _params) do
    viewer = User.of(conn)
    group_lead_section = Dashboard.group_lead_section(viewer)
    my_required_advice = Dashboard.required_advice_section(viewer)
    advice_for_me      = Dashboard.advice_for_me_section(viewer)

    render conn, "index.html", viewer: viewer,
                               group_lead_section: group_lead_section,
                               required_advice_section: my_required_advice,
                               advice_for_me: advice_for_me,
                               user: Person.changeset(viewer)

  end

  def settings(conn, %{"person" => person}) do
    User.of(conn)
    |> Person.changeset(person)
    |> People.update()

    redirect(conn, to: "/dashboard")
  end
end
