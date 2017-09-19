defmodule AdvisorWeb.PresentPageTest do
  use AdvisorWeb.ConnCase
  import PageAssertions

  alias AdvisorWeb.QuestionnaireProposal, as: Proposal
  alias AdvisorWeb.Links
  alias Advisor.Core.Questionnaire.Creator

  @sample_questions ["one", "two"]

  setup do
    proposal = Proposal.build(for: "Rabea Gleissner",
                              advisors: ["Chris Jordan", "Priya Patil"],
                              group_lead: "Felipe Sere",
                              questions: @sample_questions)
    [proposal: proposal]
  end

  @tag :skip
  test "it displays all four answers to the questionnaire", %{conn: conn, proposal: proposal} do
    %{questions: [first_id, second_id]} = proposal
    {[%{link: cj}, %{link: priya}], _, present_link} = proposal
                                                       |> Creator.create
                                                       |> Links.generate

    answers = ["#{first_id}": "something", "#{second_id}": "else"]

    conn
    |> ThroughTheWeb.login_as("Chris Jordan")
    |> post(cj, answers)

    conn
    |> ThroughTheWeb.login_as("Priya Patil")
    |> post(priya, answers)

    conn
    |> ThroughTheWeb.login_as("Felipe Sere")
    |> get(present_link)
    |> html_response(200)
    |> has_title("Advice for Rabea Gleissner")
    |> has_feedback_questions(2)
    |> has_answers(["something", "else"])
  end
end
