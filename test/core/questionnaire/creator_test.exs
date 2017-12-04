defmodule Advisor.Core.Questionnaire.CreatorTest do
  use Advisor.DataCase
  alias Advisor.Core.Questionnaire.Creator
  alias AdvisorWeb.QuestionnaireProposal
  alias Advisor.Core.Questionnaire
  alias Advisor.Test.Support.Users

  # TODO: This should be using the Support.Proposal as a builder
  test "creates a simple questionnaire" do
    [felipe, rabea, cj, priya] = Users.with(["Felipe Sere", "Rabea Gleissner", "Chris Jordan", "Priya Patil"])

    phrases = ["first question", "second question"]
    proposal = %QuestionnaireProposal{group_lead: felipe.id,
                                      requester: rabea.id,
                                      advisors: [cj.id, priya.id],
                                      questions: phrases,
                                      message: "bla"}

    created = Creator.create(proposal)

    questionnaire = Questionnaire.find(created.questionnaire)

    assert Enum.map(created.advisories, &(&1.advisor.id)) == [cj.id, priya.id]
    assert questionnaire.message == "bla"
  end

  test "message is optional" do
    [felipe, rabea, cj] = Users.with(["Felipe Sere", "Rabea Gleissner", "Chris Jordan"])

    proposal = %QuestionnaireProposal{group_lead: felipe.id,
                                      requester: rabea.id,
                                      advisors: [cj.id],
                                      questions: []}

    created = Creator.create(proposal)
    questionnaire = Questionnaire.find(created.questionnaire)

    assert questionnaire.message == nil
  end
end
