defmodule Advisor.Core.AdviceTest do
  use Advisor.DataCase
  alias Advisor.Core.{Answers, Advice}
  alias Advisor.Core.Questionnaire.Creator
  alias Advisor.Web.QuestionnaireProposal, as: Proposal

  @questions [1, 2, 3]

  test "can figure out if an advice has been answered fully" do
    christoph = advice_with("Christoph Gockel", @questions)

    answer!(christoph, with: %{"1" => "foo", "2" => "bar", "3" => "batz"})
    assert Advice.completed?(christoph, length(@questions))
  end

  test "cann tell if advice has not been answered fully" do
    christoph = advice_with("Christoph Gockel", @questions)

    answer!(christoph, with: %{"1" => "foo"})
    refute Advice.completed?(christoph, length(@questions))
  end

  def advice_with(person, questions) do
    {:ok, %{advisories: [individual]}} = Proposal.build(for: "Felipe Sere",
                                                       advisors: [person],
                                                       group_lead: "Jim Suchy",
                                                       questions: questions) |> Creator.create
    individual
  end

  def answer!(%{advice_id: id}, [with: data]) do
    Answers.store(Map.put(data, "id", id))
  end
end
