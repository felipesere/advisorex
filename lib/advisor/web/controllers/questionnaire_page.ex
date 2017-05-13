defmodule Advisor.Web.QuestionnairePage do
  use Advisor.Web, :controller
  alias Advisor.Core.People
  alias Advisor.Core.Questionnaire

  def index(conn, _params) do
    user_id = conn.cookies["user"]
    user = People.find_by(id: user_id)
    if user do
      {everybody, group_leads, questions} = Questionnaire.form_data()

      render conn, "request.html", requester: user,
                                   group_leads: group_leads,
                                   everybody: everybody,
                                   questions: questions
    else
      conn |> redirect(to: "/")
    end
  end

  def create(conn, _params) do
    conn
  end
end
