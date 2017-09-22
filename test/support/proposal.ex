defmodule Advisor.Test.Support.Proposal do
  alias Advisor.Core.People
  alias AdvisorWeb.QuestionnaireProposal

  def build([for: requester_name,
             advisors: advisors_names,
             group_lead: lead_name,
             questions: phrases]) do

    requester = People.find_by(name: requester_name)

    proposal_form = basic()
                    |> with_group_lead(lead_name)
                    |> with_questions(phrases)
                    |> with_advisors(advisors_names)

    proposal_form
    |> build(for: requester.id)
  end

  def build(params), do: build(params, for: 1)
  def build(params, [for: id]) do
    params
    |> QuestionnaireProposal.from_params()
    |> QuestionnaireProposal.for_requester(%{id: id})
  end

  def basic() do
    %{
      "proposal" => %{
        "group_lead" => "1",
        "questions" => as_html_form([1, 2]),
        "advisors" => as_html_form([1, 2])
      }
    }
  end

  def with_group_lead(%{"proposal" => proposal}, lead_name) do
    group_lead_id = People.group_lead(name: lead_name).id |> Integer.to_string()
    %{"proposal" => %{proposal | "group_lead"  => group_lead_id}}
  end

  def with_advisors(%{"proposal" => proposal}, advisor_names) do
    advisors = People.find_by(names: advisor_names)
                          |> Enum.map(&(&1.id))
                          |> as_html_form()

    %{"proposal" => %{proposal | "advisors"  => advisors}}
  end

  def with_questions(%{"proposal" => proposal}, phrases) do
    questions = phrases |> as_html_form()

    %{"proposal" => %{proposal | "questions"  => questions}}
  end

  defp as_html_form(elements) do
    elements
    |> Enum.map(fn(a) -> {Integer.to_string(a), "true"} end)
    |> Enum.into(%{})
  end
end
