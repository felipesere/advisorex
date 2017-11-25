defmodule Advisor.Core.QuestionnaireTest do
  use Advisor.DataCase
  alias Advisor.Test.Support.{Users, Proposal}

  alias Advisor.Core.Questionnaire.Creator
  alias Advisor.Core.Questionnaire

  test "finds a group leads questinnaires" do
    [felipe | _] = Users.with(["Felipe Sere", "Rabea Gleissner", "Priya Patil", "Chris Jordan", "Jim Suchy"])

    Proposal.basic()
    |> Proposal.with_group_lead(felipe.name)
    |> Proposal.build()
    |> Creator.create()

    [%{group_lead: group_lead}] = Questionnaire.all_for_group_lead(felipe.id)
    assert group_lead == felipe.id
  end
end
