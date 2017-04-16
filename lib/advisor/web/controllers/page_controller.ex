defmodule Advisor.Web.PageController do
  use Advisor.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
