defmodule Advisor.Test.Support.Proposal do
  alias Advisor.Core.People
  alias AdvisorWeb.QuestionnaireProposal

  def build(params) do
    build(params, 1)
  end
  def build(params, name) when is_binary(name) do
    build(params, People.find_by(name: name).id)
  end
  def build(params, id) do
    params
    |> QuestionnaireProposal.from_params()
    |> QuestionnaireProposal.for_requester(%{id: id})
  end

  def basic() do
    %{
      "proposal" => %{
        "group_lead" => "1",
        "questions" => as_html_form([1, 2]),
        "advisors"  => as_html_form([1, 2]),
        "message" => nil
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

  def with_message(%{"proposal" => proposal}, message) do
    %{"proposal" => %{proposal | "message" => message}}
  end

  defp as_html_form(elements) do
    elements
    |> Enum.map(fn(a) -> {Integer.to_string(a), "true"} end)
    |> Enum.into(%{})
  end
end
