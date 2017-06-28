defmodule Advisor.Web.DashboardPageTest do
  use Advisor.Web.ConnCase
  import PageAssertions

  alias Advisor.Web.QuestionnaireProposal, as: Proposal
  alias Advisor.Core.Questionnaire.Creator

  test "it displays a dashboard", %{conn: conn} do
    Proposal.build(for: "Rabea Gleissner",
                   advisors: ["Priya Patil", "Christoph Gockel"],
                   group_lead: "Felipe Sere",
                   questions: [1, 2])
                   |> Creator.create
    conn
    |> login_as("Felipe Sere")
    |> get("/dashboard")
    |> html_response(200)
    |> has_title("Hello Felipe Sere!")
  end

  def advice_open_for(html, requester) do
    assert html |> Floki.find("li > p") |> Enum.map(&Floki.text/1) == ["Advice for " <> requester]
    html
  end
end
