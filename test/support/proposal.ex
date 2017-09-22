defmodule Advisor.Test.Support.Proposal do
  alias Advisor.Core.People

  def build([for: requester_name,
             advisors: advisors_names,
             group_lead: lead_name,
             questions: phrases]) do

    requester = People.find_by(name: requester_name)
    group_lead = People.group_lead(name: lead_name)
    advisors = People.find_by(names: advisors_names)
                          |> Enum.map(&(&1.id))
                          |> as_html_form()

    questions = phrases |> as_html_form()

    proposal_form = %{"proposal" => %{
      "group_lead" => Integer.to_string(group_lead.id),
      "questions" => questions,
      "advisors" => advisors
    }}

    AdvisorWeb.QuestionnaireProposal.for_requester(proposal_form, %{id: requester.id})
  end

  defp as_html_form(elements) do
    elements
    |> Enum.map(fn(a) -> {Integer.to_string(a), "true"} end)
    |> Enum.into(%{})
  end
end
