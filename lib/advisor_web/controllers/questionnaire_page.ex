defmodule AdvisorWeb.QuestionnairePage do
  use AdvisorWeb, :controller
  alias Advisor.Core.Questionnaire.Form, as: QuestionnaireForm
  alias AdvisorWeb.Authentication.User

  plug AdvisorWeb.Authentication.Gatekeeper

  # TODO This could be a better/more-intuitive structure
  def index(conn, _params) do
    {everybody, group_leads, questions} = QuestionnaireForm.data_for(User.of(conn))

    render(conn, "request.html",
      requester: User.of(conn),
      group_leads: group_leads,
      everybody: everybody,
      questions: questions
    )
  end
end
