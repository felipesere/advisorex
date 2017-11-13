defmodule AdvisorWeb.QuestionnaireControllerTest do
  use AdvisorWeb.ConnCase

  alias Advisor.Test.Support.Proposal
  alias AdvisorWeb.QuestionnaireProposal
  alias Advisor.Core.Questionnaire.Creator
  alias Advisor.Core.Questionnaire
  alias Advisor.Core.{Answers, Advice}

  test "will delete an entire questionnaire", %{conn: conn} do
    proposal = Proposal.basic()
               |> Proposal.build()

    %QuestionnaireProposal{questions: [first_id, second_id]} = proposal

    {:ok, %{questionnaire: id, advisories: advisories}} = Creator.create(proposal)

    ThroughTheCore.answer!(advisories, with: %{first_id => "Foo", second_id => "Bar"})

    conn
    |> ThroughTheWeb.login_as("Felipe Sere")
    |> get("/questionnaire/#{id}/delete")

    refute Questionnaire.find(id)
    assert [] == Answers.find(advisories)
    assert [] == Advice.find(advisories)
  end
end