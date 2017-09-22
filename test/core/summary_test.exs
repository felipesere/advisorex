defmodule Advisor.Core.SummaryTest do
  use Advisor.DataCase

  alias Advisor.Test.Support.Proposal
  alias Advisor.Core.Questionnaire.Creator
  alias Advisor.Core.Summary

  setup do
    proposal = Proposal.basic()
               |> Proposal.build("Rabea Gleissner")

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
