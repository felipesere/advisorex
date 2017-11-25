defmodule Advisor.Core.Questionnaire.CreatorTest do
  use Advisor.DataCase
  alias Advisor.Core.Questionnaire.Creator
  alias AdvisorWeb.QuestionnaireProposal
  alias Advisor.Core.Questionnaire
  alias Advisor.Test.Support.Users

  setup do
    :ok
  end

  # TODO: This should be using the Support.Proposal as a builder
  test "creates a simple questionnaire" do
    felipe = Users.with("Felipe Sere")
    rabea = Users.with("Rabea Gleissner")
    cj = Users.with("Chris Jordan")
    priya = Users.with("Priya Patil")

    phrases = ["first question", "second question"]
    proposal = %QuestionnaireProposal{group_lead: felipe.id,
                                      requester: rabea.id,
                                      advisors: [cj.id, priya.id],
                                      questions: phrases,
                                      message: "bla"}

    {:ok, created} = Creator.create(proposal)

    questionnaire = Questionnaire.find(created.questionnaire)

    assert Enum.map(created.advisories, &(&1.advisor.id)) == [cj.id, priya.id]
    assert questionnaire.message == "bla"
  end

  test "message is optional" do
    felipe = Users.with("Felipe Sere")
    rabea = Users.with("Rabea Gleissner")
    cj = Users.with("Chris Jordan")

    proposal = %QuestionnaireProposal{group_lead: felipe.id,
                                      requester: rabea.id,
                                      advisors: [cj.id],
                                      questions: []}

    {:ok, created} = Creator.create(proposal)
    questionnaire = Questionnaire.find(created.questionnaire)

    assert questionnaire.message == nil
  end
end
