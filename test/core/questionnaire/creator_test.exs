defmodule Advisor.Core.Questionnaire.CreatorTest do
  use Advisor.DataCase
  alias Advisor.Core.Questionnaire.Creator
  alias AdvisorWeb.QuestionnaireProposal

  test "creates a simple questionnaire" do
    proposal = %QuestionnaireProposal{group_lead: 1,
                                      requester: 2,
                                      advisors: [2, 9],
                                      questions: [7]}

    {:ok, created} = Creator.create(proposal)
    assert created.questionnaire
    assert Enum.map(created.advisories, &(&1.advisor.id)) == [2, 9]
  end

end
