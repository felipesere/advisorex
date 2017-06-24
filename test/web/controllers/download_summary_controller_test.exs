defmodule Advisor.Web.DownloadSummaryControllerTest do
  use Advisor.Web.ConnCase

  alias Advisor.Web.QuestionnaireProposal, as: Proposal
  alias Advisor.Web.Links
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
      |> login_as(link.person.name)
      |> post(link.link, @answers)
    end)
  end

  test "downloads answers as CSV", %{conn: conn, proposal: proposal} do
    {links, _, present_link} = proposal
                                |> Creator.create
                                |> Links.generate

    answer!(conn, links)

    conn
    |> login_as("Felipe Sere")
    |> get("#{present_link}/download.csv")
    |> response_content_type(:csv)
  end
end
