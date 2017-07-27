defmodule AdvisorWeb.ProgressPageTest do
  use AdvisorWeb.ConnCase
  import PageAssertions
  alias AdvisorWeb.QuestionnaireProposal, as: Proposal
  alias AdvisorWeb.Links
  alias Advisor.Core.Questionnaire.Creator

  @sample_questions [5, 6]

  setup do
    proposal = Proposal.build(for: "Rabea Gleissner",
                              advisors: ["Chris Jordan", "Priya Patil"],
                              group_lead: "Felipe Sere",
                              questions: @sample_questions)
    [proposal: proposal]
  end

  test "shows the progress filling in the questionnaires", %{conn: conn,
                                                             proposal: proposal} do
    {_, progress_page, _} = proposal
                            |> Creator.create
                            |> Links.generate

    conn
    |> ThroughTheWeb.login_as("Felipe Sere")
    |> get(progress_page)
    |> html_response(200)
    |> has_requester("Rabea Gleissner")
    |> has_advisors(["Chris Jordan", "Priya Patil"])
  end

  test "shows that an advisors has completed the advice form", %{conn: conn,
                                                                 proposal: proposal} do
    proposal =  %{proposal | questions: [1]}
    {[%{link: link} | _], progress_page, _} = proposal
                                           |> Creator.create
                                           |> Links.generate

    conn
    |> ThroughTheWeb.login_as("Chris Jordan")
    |> post(link, ["1": "someting"])

    conn
    |> ThroughTheWeb.login_as("Felipe Sere")
    |> get(progress_page)
    |> html_response(200)
    |> has_completed_advice()
    |> has_continue_button_with("Waiting for further responses")
  end

  test "all completed feedback", %{conn: conn, proposal: proposal} do
    {[%{link: cj}, %{link: priya}], progress_page, _} = proposal
                                                    |> Creator.create
                                                    |> Links.generate

    answers = ["1": "something", "2": "else"]

    conn
    |> ThroughTheWeb.login_as("Chris Jordan")
    |> post(cj, answers)

    conn
    |> ThroughTheWeb.login_as("Priya Patil")
    |> post(priya, answers)

    conn
    |> ThroughTheWeb.login_as("Felipe Sere")
    |> get(progress_page)
    |> html_response(200)
    |> has_continue_button_with("We are good to go")
  end
end
