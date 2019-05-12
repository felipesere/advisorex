defmodule AdvisorWeb.QuestionnaireProposalTest do
  use ExUnit.Case
  alias AdvisorWeb.QuestionnaireProposal

  @user %{id: 1}

  @new %{
    "proposal" => %{
      "advisors" => %{"1" => "false", "4" => "true", "5" => "true"},
      "mentor" => "11",
      "questions" => %{"4" => "false", "13" => "true"},
      "message" => "Bla bla bla"
    }
  }

  test "can extract mentor from form data" do
    proposal =
      @new
      |> QuestionnaireProposal.from_params()
      |> QuestionnaireProposal.for_mentee(@user)

    assert proposal.mentor == 11
    assert proposal.advisors == [4, 5]
    assert proposal.questions == ["Is this person the technical lead for stories?"]
    assert proposal.mentee == 1
    assert proposal.message == "Bla bla bla"
  end
end
