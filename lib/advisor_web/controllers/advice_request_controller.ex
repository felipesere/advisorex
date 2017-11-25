defmodule AdvisorWeb.AdviceRequestController do
  use AdvisorWeb, :controller
  alias AdvisorWeb.QuestionnaireProposal
  alias Advisor.Core.Questionnaire.Creator
  alias AdvisorWeb.Authentication.User

  plug  AdvisorWeb.Authentication.Gatekeeper

  def create(conn, params) do
    {:ok, %{advisories: a, questionnaire: q}} = params
                                  |> QuestionnaireProposal.from_params()
                                  |> QuestionnaireProposal.for_requester(User.found_in(conn))
                                  |> Creator.create

    render conn, "links.html", advice: a, questionnaire: q
  end
end
