defmodule Advisor.Web.LandingPage do
  use Advisor.Web, :controller

  def index(conn, _params) do
    target = case conn.cookies["target"] do
      nil  -> false
      "deleted" -> false
      x -> x
    end

    render conn, "index.html", button: "Ask for advice",
                               target: target,
                               message: false
  end
end
