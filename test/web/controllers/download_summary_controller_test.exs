defmodule Advisor.Web.DownloadSummaryControllerTest do
  use Advisor.Web.ConnCase

  alias Advisor.Web.QuestionnaireProposal, as: Proposal
  alias Advisor.Web.Links
  alias Advisor.Core.Questionnaire.Creator

  setup do
    proposal = Proposal.build(for: "Rabea Gleissner",
                              advisors: ["Chris Jordan", "Priya Patil"],
                              group_lead: "Felipe Sere",
                              questions: ["first", "second"])

    %{questions: questions} = proposal

    [proposal: proposal, questions: questions]
  end

  test "downloads answers as CSV", %{conn: conn, proposal: proposal, questions: questions} do
    {links, _, present_link} = proposal
                                |> Creator.create
                                |> Links.generate

    answers = questions
              |> Enum.map(fn(id) -> {String.to_atom(id), "some answer"} end)
              |> Keyword.new
    ThroughTheWeb.answer!(conn, links, answers)

    conn
    |> ThroughTheWeb.login_as("Felipe Sere")
    |> get("#{present_link}/download.csv")
    |> response_content_type(:csv)
  end
end
