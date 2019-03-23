defmodule Advisor.Core.QuestionnaireTest do
  use Advisor.DataCase
  alias Advisor.Test.Support.Sample

  alias Advisor.Core.Questionnaire

  test "finds a group leads questinnaires" do
    questionnaire =
      Sample.questionnaire(
        group_lead: "Felipe Sere",
        requester: "Rabea Gleissner",
        advisors: ["Priya Patil"]
      )

    assert [questionnaire] == Questionnaire.all_for_group_lead(questionnaire.group_lead_id)
  end
end
