defmodule Advisor.Core.Questionnaire.CreatorTest do
  use Advisor.DataCase
  alias Advisor.Core.Questionnaire.Creator
  alias AdvisorWeb.QuestionnaireProposal

  # TODO: This shoudl be using the Support.Proposal as a builder
  test "creates a simple questionnaire" do
    phrases = ["first question", "second question"]
    proposal = %QuestionnaireProposal{group_lead: 1,
                                      requester: 2,
                                      advisors: [2, 9],
                                      questions: phrases}

    {:ok, created} = Creator.create(proposal)
    assert created.questionnaire
    assert Enum.map(created.advisories, &(&1.advisor.id)) == [2, 9]
  end

end
