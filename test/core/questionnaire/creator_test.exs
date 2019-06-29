defmodule Advisor.Questionnaire.CreatorTest do
  use Advisor.DataCase
  alias Advisor.Questionnaire.Creator
  alias AdvisorWeb.DraftQuestionnaire
  alias Advisor.Test.Support.Users

  test "creates a simple questionnaire" do
    [felipe, rabea, cj, priya] =
      Users.with(["Felipe Sere", "Rabea Gleissner", "Chris Jordan", "Priya Patil"])

    phrases = ["first question", "second question"]

    draft = %DraftQuestionnaire{
      mentor: felipe.id,
      mentee: rabea.id,
      advisors: [cj.id, priya.id],
      questions: phrases,
      message: "bla"
    }

    created = Creator.create(draft)

    assert Enum.map(created.advice, & &1.advisor.id) == [cj.id, priya.id]
    assert created.message == "bla"
    assert length(created.questions) == 2
  end

  test "message is optional" do
    [felipe, rabea, cj] = Users.with(["Felipe Sere", "Rabea Gleissner", "Chris Jordan"])

    draft = %DraftQuestionnaire{
      mentor: felipe.id,
      mentee: rabea.id,
      advisors: [cj.id],
      questions: []
    }

    created = Creator.create(draft)

    assert created.message == nil
  end
end
