defmodule AdvisorWeb.DraftQuestionnaireTest do
  use ExUnit.Case
  alias AdvisorWeb.DraftQuestionnaire

  @user %{id: 1}

  @new %{
    "draft" => %{
      "advisors" => %{"1" => "false", "4" => "true", "5" => "true"},
      "mentor" => "11",
      "questions" => %{"4" => "false", "13" => "true"},
      "message" => "Bla bla bla"
    }
  }

  test "can extract mentor from form data" do
    draft =
      @new
      |> DraftQuestionnaire.from_params()
      |> DraftQuestionnaire.for_mentee(@user)

    assert draft.mentor == 11
    assert draft.advisors == [4, 5]
    assert draft.questions == ["Is this person the technical lead for stories?"]
    assert draft.mentee == 1
    assert draft.message == "Bla bla bla"
  end
end
