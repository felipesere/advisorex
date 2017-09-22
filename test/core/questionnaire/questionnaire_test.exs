defmodule Advisor.Core.QuestionnaireTest do
  use Advisor.DataCase
  alias Advisor.Test.Support.Proposal

  alias Advisor.Core.Questionnaire.Creator
  alias Advisor.Core.People
  alias Advisor.Core.Questionnaire

  test "finds a group leads questinnaires" do
    felipe = People.find_by(name: "Felipe Sere")


    proposal = Proposal.basic()
               |> Proposal.with_group_lead(felipe.name)
               |> Proposal.build()

    Creator.create(proposal)

    [%{group_lead: group_lead}] = Questionnaire.all_for_group_lead(felipe.id)
    assert group_lead == felipe.id

  end
end
