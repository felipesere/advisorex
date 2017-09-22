defmodule Advisor.Core.AdviceTest do
  alias Advisor.Test.Support.Proposal

  use Advisor.DataCase
  alias Advisor.Core.Advice
  alias Advisor.Core.Questionnaire.Creator

  @phrases [1, 2, 3]

  # TODO: These tests look... aweful!
  test "can figure out if an advice has been answered fully" do
    christoph = advised_by("Christoph Gockel", @phrases)

    # this can not be right. but I'll wait for a failure to direct me...
    ThroughTheCore.answer!(christoph, with: %{"1" => "foo", "2" => "bar", "3" => "batz"})
    advice = Advice.find(christoph.id)
    assert Advice.completed?(advice, length(@phrases))
  end

  test "can tell if advice has not been answered fully" do
    christoph = advised_by("Christoph Gockel", @phrases)

    ThroughTheCore.answer!(christoph, with: %{"1" => "foo"})
    advice = Advice.find(christoph.id)
    refute Advice.completed?(advice, length(@phrases))
  end

  def advised_by(person, questions) do
    {:ok, %{advisories: [individual]}} = Proposal.basic()
                                         |> Proposal.with_advisors([person])
                                         |> Proposal.with_questions(questions)
                                         |> Proposal.build()
                                         |> Creator.create

    individual
  end
end
