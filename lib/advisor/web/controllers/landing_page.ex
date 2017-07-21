defmodule Advisor.Web.LandingPage do
  use Advisor.Web, :controller
  alias Advisor.Web.Authentication.User
  alias Advisor.Web.Redirect

  plug  Advisor.Web.Authentication.Gatekeeper, redirect: false

  def index(conn, _params) do
    data = case User.of(conn) do
      nil -> [title: "Advisor",                  logged_in: false]
      %{name: name} -> [title: "Hello #{name}!", logged_in: true]
    end
    render conn, "index.html", Keyword.merge(data, redirect_to: Redirect.target(conn))
  end
end
