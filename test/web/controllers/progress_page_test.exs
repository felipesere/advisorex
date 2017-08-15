defmodule Advisor.Web.ProgressPageTest do
  use Advisor.Web.ConnCase
  import PageAssertions
  alias Advisor.Web.QuestionnaireProposal, as: Proposal
  alias Advisor.Web.Links
  alias Advisor.Core.Questionnaire.Creator
  alias Advisor.Core.Questionnaire

  @sample_questions ["first", "second"]

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
    proposal =  %{proposal | questions: ["blob"]}
    questionnaires = Creator.create(proposal)
    {[%{link: link} | _], progress_page, _} = Links.generate(questionnaires)

    {:ok, %{questionnaire: questionnaire_id}} = questionnaires


    answers = questionnaire_id
              |> Questionnaire.questions
              |> Enum.map(fn(id) -> {String.to_atom(id), "some answer"} end)
              |> Keyword.new

    conn
    |> ThroughTheWeb.login_as("Chris Jordan")
    |> post(link, answers)

    conn
    |> ThroughTheWeb.login_as("Felipe Sere")
    |> get(progress_page)
    |> html_response(200)
    |> has_completed_advice()
    |> has_continue_button_with("Waiting for further responses")
  end

  test "all completed feedback", %{conn: conn, proposal: proposal} do
    questionnaire = Creator.create(proposal)
    {[%{link: cj}, %{link: priya}], progress_page, _} = Links.generate(questionnaire)

    {:ok, %{questionnaire: questionnaire_id}} = questionnaire

    answers = questionnaire_id
              |> Questionnaire.questions
              |> Enum.map(fn(id) -> {String.to_atom(id), "some answer"} end)
              |> Keyword.new

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
