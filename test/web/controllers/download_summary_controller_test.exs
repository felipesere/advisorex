defmodule AdvisorWeb.DownloadSummaryControllerTest do
  use AdvisorWeb.ConnCase

  alias AdvisorWeb.QuestionnaireProposal, as: Proposal
  alias AdvisorWeb.Links
  alias Advisor.Core.Questionnaire.Creator

  @answers  ["1": "something", "2": "else"]

  setup do
    proposal = Proposal.build(for: "Rabea Gleissner",
                              advisors: ["Chris Jordan", "Priya Patil"],
                              group_lead: "Felipe Sere",
                              questions: [1, 2])
    [proposal: proposal]
  end

  def answer!(conn, links) do
    Enum.each(links, fn (link) ->
      conn
      |> ThroughTheWeb.login_as(link.person.name)
      |> post(link.link, @answers)
    end)
  end

  test "downloads answers as CSV", %{conn: conn, proposal: proposal} do
    {links, _, present_link} = proposal
                                |> Creator.create
                                |> Links.generate

    ThroughTheWeb.answer!(conn, links, @answers)

    conn
    |> ThroughTheWeb.login_as("Felipe Sere")
    |> get("#{present_link}/download.csv")
    |> response_content_type(:csv)
  end
end
