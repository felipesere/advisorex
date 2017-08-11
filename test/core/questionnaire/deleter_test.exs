defmodule Advisor.Core.Questionnaire.DeleterTest do
  use Advisor.DataCase

  alias Advisor.Web.QuestionnaireProposal, as: Proposal
  alias Advisor.Core.Questionnaire.{Creator, Deleter}
  alias Advisor.Core.Questionnaire
  alias Advisor.Core.{Answers, Advice}

  test "will delete an entire questionnaire" do
    proposal = Proposal.build(for: "Felipe Sere",
                              advisors: ["Rabea Gleissner", "Nick Dyer"],
                              group_lead: "Jim Suchy",
                              questions: ["1", "2"])

    {:ok, %{questionnaire: id, advisories: advisories}} = Creator.create(proposal)

    ThroughTheCore.answer!(advisories, with: %{"1" => "Foo", "2" => "Bar"})

    Deleter.delete(id)

    assert [] == Answers.find(advisories)
    assert [] == Advice.find(advisories)
    refute Questionnaire.find(id)
  end
end
