defmodule Advisor.Web.DashboardPageTest do
  use Advisor.Web.ConnCase
  import PageAssertions

  alias Advisor.Web.QuestionnaireProposal, as: Proposal
  alias Advisor.Core.Questionnaire.Creator

  @group_lead "Felipe Sere"

  def advice_for(person, advisors) do
      proposal = Proposal.build(for: person,
                     advisors: advisors,
                     group_lead: @group_lead,
                     questions: [1, 2])
    Creator.create(proposal)
  end

  test "it displays a dashboard", %{conn: conn} do
    advice_for("Rabea Gleissner", ["Priya Patil", "Sarah Johnston"])
    advice_for("Chris Jordan", ["Nick Dyer", "Jim Suchy"])

    conn
    |> login_as(@group_lead)
    |> get("/dashboard")
    |> html_response(200)
    |> has_title("Hello Felipe Sere!")
    |> advice_open_for("Rabea Gleissner")
    |> advice_open_for("Chris Jordan")
  end

  def advice_open_for(html, requester) do
    advice = fn(text) -> text =~ "Advice for " <> requester end
    assert html
            |> Floki.find("li > p")
            |> Enum.map(&Floki.text/1)
            |> Enum.any?(advice)
    html
  end
end
