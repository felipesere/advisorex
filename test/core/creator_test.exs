defmodule Advisor.Core.CreatorTest do
  use Advisor.DataCase
  alias Advisor.Core.Creator
  alias Advisor.Web.QuestionnaireProposal

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
