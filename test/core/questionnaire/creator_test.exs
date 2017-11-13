defmodule Advisor.Core.Questionnaire.CreatorTest do
  use Advisor.DataCase
  alias Advisor.Core.Questionnaire.Creator
  alias AdvisorWeb.QuestionnaireProposal
  alias Advisor.Core.Questionnaire

  # TODO: This should be using the Support.Proposal as a builder
  test "creates a simple questionnaire" do
    phrases = ["first question", "second question"]
    proposal = %QuestionnaireProposal{group_lead: 1,
                                      requester: 2,
                                      advisors: [2, 9],
                                      questions: phrases,
                                      message: "bla"}

    {:ok, created} = Creator.create(proposal)

    questionnaire = Questionnaire.find(created.questionnaire)

    assert Enum.map(created.advisories, &(&1.advisor.id)) == [2, 9]
    assert questionnaire.message == "bla"
  end

  test "message is optional" do
    proposal = %QuestionnaireProposal{group_lead: 1,
                                      requester: 2,
                                      advisors: [2, 9],
                                      questions: []}

    {:ok, created} = Creator.create(proposal)
    questionnaire = Questionnaire.find(created.questionnaire)

    assert questionnaire.message == nil
  end


end
