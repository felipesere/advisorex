defmodule Advisor.Web.QuestionnaireProposalTest do
  use ExUnit.Case
  alias Advisor.Web.QuestionnaireProposal

  @user %{id: 1}
  @data %{"group_lead" => "11",
          "people" => %{"4" => "on", "5" => "on"},
          "questions" => %{"13" => "on"}}

  test "can extract group_lead from form data" do
    proposal = QuestionnaireProposal.for_requester(@data, @user)

    assert proposal.group_lead == 11
    assert proposal.advisors == [4, 5]
    assert proposal.questions == [13]
    assert proposal.requester == 1
  end
end
