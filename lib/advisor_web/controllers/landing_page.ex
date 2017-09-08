defmodule AdvisorWeb.LandingPage do
  use AdvisorWeb, :controller
  alias AdvisorWeb.Authentication.User
  alias AdvisorWeb.Redirect

  plug  AdvisorWeb.Authentication.Gatekeeper, redirect: false

  def index(conn, _params) do
    data = case User.of(conn) do
      # TODO: This is where nill could be something better
      nil ->           [title: "Advisor",        logged_in: false]
      %{name: name} -> [title: "Hello #{name}!", logged_in: true]
    end
    render conn, "index.html", Keyword.merge(data, redirect_to: Redirect.target(conn))
  end
end
