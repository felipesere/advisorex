defmodule Advisor.Core.SummaryTest do
  use Advisor.DataCase

  alias AdvisorWeb.QuestionnaireProposal, as: Proposal
  alias Advisor.Core.Questionnaire.Creator
  alias Advisor.Core.Summary

  setup do
    proposal = Proposal.build(for: "Rabea Gleissner",
                              advisors: ["Chris Jordan", "Priya Patil"],
                              group_lead: "Felipe Sere",
                              questions: [1, 2])

    [proposal: proposal]
  end

  test "presents tabular data for a given questionnaire", %{proposal: proposal} do
    {:ok, created} = Creator.create(proposal)
    %{advisories: advisories, questionnaire: id} = created

    ThroughTheCore.answer!(advisories, with: %{"1" => "Foo", "2" => "Bar"})

    [_headers, first, _second] = Summary.for_download(id)
    assert length(first) == 5
  end
end
