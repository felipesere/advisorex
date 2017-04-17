defmodule Advisor.Web.QuestionnairePage do
  use Advisor.Web, :controller

  def index(conn, _params) do
    user_id = conn.cookies["user"]
    user = Advisor.Core.People.find_by(id: user_id)
    if user do
      render conn, "request.html", requester: user
    else
      conn |> redirect(to: "/")
    end
  end
end
