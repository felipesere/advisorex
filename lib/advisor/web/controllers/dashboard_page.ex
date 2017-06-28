defmodule Advisor.Web.DashboardPage do
  use Advisor.Web, :controller
  alias Advisor.Core.People
  alias Advisor.Web.Authentication.User

  plug Advisor.Web.Authentication.Gatekeeper

  def index(conn, params) do
    viewer = User.of(conn)
    render conn, "index.html", viewer: viewer,
                               person: People.find_by(name: "Uku Taht")
  end
end
