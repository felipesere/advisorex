defmodule Advisor.Web.QuestionnaireProposalTest do
  use ExUnit.Case
  alias Advisor.Web.QuestionnaireProposal

  test "can extract group_lead from form data" do
   data = %{"group_lead" => "11", "people" => %{"4" => "on"}, "questions" => %{"13" => "on"}}

    assert QuestionnaireProposal.from(data).group_lead == 11
  end

  test "can extract multiple requesters from form data" do
   data = %{"group_lead" => "11", "people" => %{"4" => "on", "5" => "on"}, "questions" => %{"13" => "on"}}

    assert QuestionnaireProposal.from(data).requester == [4,5]
  end

  test "can extract multiple questions" do
   data = %{"group_lead" => "11", "people" => %{"4" => "on", "5" => "on"}, "questions" => %{"13" => "on"}}

    assert QuestionnaireProposal.from(data).questions == [13]
  end
end
