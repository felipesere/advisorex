defmodule Advisor.QuestionnaireTest do
  use Advisor.DataCase
  alias Advisor.Test.Support.Sample

  alias Advisor.Questionnaire

  test "finds a mentoes questionnaires" do
    questionnaire =
      Sample.questionnaire(
        mentor: "Felipe Sere",
        mentee: "Rabea Gleissner",
        advisors: ["Priya Patil"]
      )

    assert [questionnaire] == Questionnaire.all_for_mentor(questionnaire.mentor_id)
  end
end
