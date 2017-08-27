defmodule Advisor.Core.AdviceTest do
  use Advisor.DataCase
  alias Advisor.Core.Advice
  alias Advisor.Core.Questionnaire.Creator
  alias AdvisorWeb.QuestionnaireProposal, as: Proposal

  @phrases ["first", "second", "third"]

  test "can figure out if an advice has been answered fully" do
    christoph = advised_by("Christoph Gockel", @phrases)

    # this can not be right. but I'll wait for a failure to direct me...
    ThroughTheCore.answer!(christoph, with: %{"1" => "foo", "2" => "bar", "3" => "batz"})
    assert Advice.completed?(christoph, length(@phrases))
  end

  test "can tell if advice has not been answered fully" do
    christoph = advised_by("Christoph Gockel", @phrases)

    ThroughTheCore.answer!(christoph, with: %{"1" => "foo"})
    refute Advice.completed?(christoph, length(@phrases))
  end

  def advised_by(person, questions) do
    {:ok, %{advisories: [individual]}} = Proposal.build(for: "Felipe Sere",
                                                       advisors: [person],
                                                       group_lead: "Jim Suchy",
                                                       questions: questions) |> Creator.create
    individual
  end
end
