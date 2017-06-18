defmodule Advisor.Web.PresentPage do
  use Advisor.Web, :controller
  alias Advisor.Core.People

  def index(conn, _params) do
    render conn, "index.html", request: People.find_by(name: "Rabea Gleissner")
  end
end
