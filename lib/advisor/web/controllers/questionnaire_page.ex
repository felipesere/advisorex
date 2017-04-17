defmodule Advisor.Web.QuestionnairePage do
  use Advisor.Web, :controller
  alias Advisor.Core.People
  alias Advisor.Core.Questions

  def index(conn, _params) do
    user_id = conn.cookies["user"]
    user = People.find_by(id: user_id)
    if user do
      everybody = People.everybody()
      group_leads = Enum.filter(everybody, &(&1.is_group_lead))
      questions = Questions.all()

      render conn, "request.html", requester: user, group_leads: group_leads, everybody: everybody, questions: questions
    else
      conn |> redirect(to: "/")
    end
  end
end
