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
                              questions: [1, 2])

    {:ok, %{questionnaire: id, advisories: advisories}} = Creator.create(proposal)

    answer!(advisories, with: %{"1" => "Foo", "2" => "Bar"})

    Deleter.delete(id)

    assert [] == Answers.find(advisories)
    assert [] == Advice.find(advisories)
    refute Questionnaire.find(id)
  end

  def answer!(advisories, data) when is_list(advisories) do
    advisories
    |> Enum.each(fn(advisory) -> answer!(advisory, data) end)
  end
  def answer!(%{advice_id: id}, [with: data]) do
    Answers.store(Map.put(data, "id", id))
  end
end
