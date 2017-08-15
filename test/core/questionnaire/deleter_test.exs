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
                              questions: ["first", "second"])

    %Proposal{questions: [first_id, second_id]} = proposal

    {:ok, %{questionnaire: id, advisories: advisories}} = Creator.create(proposal)

    ThroughTheCore.answer!(advisories, with: %{first_id => "Foo", second_id => "Bar"})

    Deleter.delete(id)

    assert [] == Answers.find(advisories)
    assert [] == Advice.find(advisories)
    refute Questionnaire.find(id)
  end
end
