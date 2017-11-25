defmodule AdvisorWeb.QuestionnaireControllerTest do
  use AdvisorWeb.ConnCase

  alias Advisor.Test.Support.{Proposal, Users}
  alias AdvisorWeb.QuestionnaireProposal
  alias Advisor.Core.{Answers, Advice, Questionnaire, Questionnaire.Creator}

  test "will delete an entire questionnaire", %{conn: conn} do
    Users.with(["Felipe Sere", "Rabea Gleissner", "Chris Jordan"])
    proposal = Proposal.basic()
               |> Proposal.build()

    %QuestionnaireProposal{questions: [first_id, second_id]} = proposal

    {:ok, %{questionnaire: q, advisories: advisories}} = Creator.create(proposal)

    ThroughTheCore.answer!(advisories, with: %{first_id => "Foo", second_id => "Bar"})

    conn
    |> ThroughTheWeb.login_as("Felipe Sere")
    |> get("/questionnaire/#{q.id}/delete")

    refute Questionnaire.find(q)
    assert [] == Answers.find(advisories)
    assert [] == Advice.find(advisories)
  end
end
