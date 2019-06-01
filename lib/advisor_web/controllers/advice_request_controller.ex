defmodule AdvisorWeb.AdviceRequestController do
  use AdvisorWeb, :controller
  alias AdvisorWeb.QuestionnaireProposal
  alias Advisor.Questionnaire.Creator
  alias Advisor.Notifications
  alias AdvisorWeb.Authentication.User

  plug AdvisorWeb.Authentication.Gatekeeper

  def create(conn, params) do
    questionnaire =
      params
      |> QuestionnaireProposal.from_params()
      |> QuestionnaireProposal.for_mentee(User.found_in(conn))
      |> Creator.create()

    Notifications.about_new_questionnaire(questionnaire)

    render(conn, "links.html", advice: questionnaire.advice, questionnaire: questionnaire)
  end
end
