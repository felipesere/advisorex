defmodule Advisor.Web.QuestionnairePage do
  use Advisor.Web, :controller
  alias Advisor.Core.Questionnaire.Form, as: QuestionnaireForm
  alias Advisor.Web.Authentication.User

  plug  Advisor.Web.Authentication.Gatekeeper

  def index(conn, _params) do
    {everybody, group_leads, questions} = QuestionnaireForm.data()

    render conn, "request.html", requester: User.of(conn),
      group_leads: group_leads,
      everybody: everybody,
      questions: questions
  end
end
