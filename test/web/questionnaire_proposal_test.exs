defmodule Advisor.Web.QuestionnaireProposalTest do
  use ExUnit.Case
  alias Advisor.Web.QuestionnaireProposal

  @user %{id: 1}

  @new %{"proposal" => %{"advisors" => %{"1" => "false", "4" => "true", "5" => "true"}, 
                         "group_lead" => "11",
                         "questions" => %{"4" => "false", "13" => "true"}}}

  test "can extract group_lead from form data" do
    proposal = QuestionnaireProposal.for_requester(@new, @user)

    assert proposal.group_lead == 11
    assert proposal.advisors == [4, 5]
    assert proposal.questions == [13]
    assert proposal.requester == 1
  end
end
