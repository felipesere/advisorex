defmodule AdvisorWeb.LandingPage do
  use AdvisorWeb, :controller
  alias AdvisorWeb.Authentication.User
  alias AdvisorWeb.Redirect
  alias Advisor.Core.Questionnaire

  plug  AdvisorWeb.Authentication.Gatekeeper, redirect: false

  def index(conn, _params) do
    user = User.of(conn)
    data = case user do
      nil ->           [title: "Advisor",        logged_in: false, existing_questionnaire: false]
      %{name: name} -> [title: "Hello #{name}!", logged_in: true, existing_questionnaire: Questionnaire.with_requester(user.id)]
    end
    render conn, "index.html", Keyword.merge(data, redirect_to: Redirect.target(conn))
  end
end
