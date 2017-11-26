defmodule AdvisorWeb.LandingPage do
  use AdvisorWeb, :controller
  alias AdvisorWeb.Authentication.User
  alias Advisor.Core.Questionnaire

  plug  AdvisorWeb.Authentication.Gatekeeper, redirect: false

  @defaults [title: "Advisor", logged_in: false, existing_questionnaire: false, redirect_to: "/"]

  def index(conn, _params) do
    user = User.of(conn)
    target = target(conn)
    render conn, "index.html", data_for(user, target)
  end

  def data_for(nil, _) do
    @defaults
  end
  def data_for(user, target) do
    [
      title: "Hello #{user.name}!",
      logged_in: true,
      existing_questionnaire: Questionnaire.with_requester(user.id),
      redirect_to: target
    ]
  end

  def target(conn), do: get_session(conn, :target) || "/"
end
