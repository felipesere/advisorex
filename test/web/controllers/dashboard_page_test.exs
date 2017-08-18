defmodule Advisor.Web.DashboardPageTest do
  use Advisor.Web.ConnCase

  alias Advisor.Web.QuestionnaireProposal, as: Proposal
  alias Advisor.Core.Questionnaire.Creator
  alias Advisor.Core.Answers

  @group_lead "Felipe Sere"
  @questions [1, 2]
  @answers  %{"1" => "something", "2" => "else"}

  def advice_for(person, advisors) do
      proposal = Proposal.build(for: person,
                     advisors: advisors,
                     group_lead: @group_lead,
                     questions: @questions)
    Creator.create(proposal)
  end

  test "it shows a section for group leads" do
    rabea = "Rabea Gleissner"
    chris = "Chris Jordan"
    advice_for(rabea, ["Priya Patil", "Sarah Johnston"])
    advice_for(chris, ["Nick Dyer", "Jim Suchy"])

    dashboard_page = login_to_dashboard_as(@group_lead)

    assert dashboard_page.status == 200
    assert page_contains?(dashboard_page.resp_body, "Hello Felipe Sere!")
    assert page_contains?(dashboard_page.resp_body, "Advice for " <> rabea)
    assert page_contains?(dashboard_page.resp_body, "Advice for " <> chris)
  end

  test "it shows the advice you still have to give" do
    rabea = "Rabea Gleissner"
    chris = "Chris Jordan"
    advice_for(rabea, ["Priya Patil", "Sarah Johnston"])
    advice_for(chris, ["Priya Patil", "Jim Suchy"])

    dashboard_page = login_to_dashboard_as("Priya Patil")

    assert page_contains?(dashboard_page.resp_body, rabea)
    assert page_contains?(dashboard_page.resp_body, chris)
    refute page_contains?(dashboard_page.resp_body, "Advice for")
  end

  test "it doesn't show advice you have already given" do
    rabea = "Rabea Gleissner"
    priya = "Priya Patil"
    {:ok, %{advisories: [%{id: priya_advice_id}]}} = advice_for(rabea, [priya])
    Answers.store(Map.put(@answers, "id", priya_advice_id))

    dashboard_page = login_to_dashboard_as(priya)

    refute page_contains?(dashboard_page.resp_body, rabea)
  end

  test "it shows who still has to give you advice" do
    rabea = "Rabea Gleissner"
    priya = "Priya Patil"
    sarah = "Sarah Johnston"
    advice_for(rabea, [priya, sarah])

    dashboard_page = login_to_dashboard_as(rabea)

    assert page_contains?(dashboard_page.resp_body, priya)
    assert page_contains?(dashboard_page.resp_body, sarah)
  end

  def login_to_dashboard_as(person) do
    updated_conn = ThroughTheWeb.login_as(build_conn(), person)
    get updated_conn, dashboard_page_path(updated_conn, :index)
  end

  defp page_contains?(html, string) do
    String.contains?(html, string)
  end
end
