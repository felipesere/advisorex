defmodule AdvisorWeb.DownloadSummaryControllerTest do
  use AdvisorWeb.ConnCase
  alias Advisor.Test.Support.Users

  alias Advisor.Test.Support.Proposal
  alias AdvisorWeb.Links
  alias Advisor.Core.Questionnaire.Creator

  setup do
    Users.with(["Rabea Gleissner", "Felipe Sere", "Jim Suchy", "Chris Jordan"])

    proposal = Proposal.basic()
               |> Proposal.with_advisors(["Jim Suchy", "Chris Jordan"])
               |> Proposal.build("Rabea Gleissner")

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
