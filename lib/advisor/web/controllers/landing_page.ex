defmodule Advisor.Web.LandingPage do
  use Advisor.Web, :controller

  def index(conn, _params) do
    render conn, "index.html", button: "Ask for advice",
                               target: false,
                               message: false
  end
end
