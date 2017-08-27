defmodule Advisor.Core.QuestionnaireTest do
  use Advisor.DataCase

  alias AdvisorWeb.QuestionnaireProposal, as: Proposal
  alias Advisor.Core.Questionnaire.Creator
  alias Advisor.Core.People
  alias Advisor.Core.Questionnaire

  test "finds a group leads questinnaires" do
    felipe = People.find_by(name: "Felipe Sere")

    proposal = Proposal.build(for: "Rabea Gleissner",
                   advisors: ["Christoph Gockel"],
                   group_lead: felipe.name,
                   questions: ["first", "second"])
    Creator.create(proposal)

    [%{group_lead: group_lead}] = Questionnaire.for_group_lead(felipe.id)
    assert group_lead == felipe.id

  end
end
