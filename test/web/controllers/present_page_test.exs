defmodule Advisor.Web.PresentPageTest do
  use Advisor.Web.ConnCase

  alias Advisor.Web.QuestionnaireProposal, as: Proposal
  alias Advisor.Web.Links
  alias Advisor.Core.Creator

  @sample_questions [5, 6]

  setup do
    proposal = Proposal.build(for: "Rabea Gleissner",
                              advisors: ["Chris Jordan", "Priya Patil"],
                              group_lead: "Felipe Sere",
                              questions: @sample_questions)
    [proposal: proposal]
  end

  test "it displays all four answers to the questionnaire", %{conn: conn, proposal: proposal} do
    {[%{link: cj}, %{link: priya}], _, present_link} = proposal
                                                                   |> Creator.create
                                                                   |> Links.generate
    answers = ["1": "something", "2": "else"]

    conn
    |> login_as("Chris Jordan")
    |> post(cj, answers)

    conn
    |> login_as("Priya Patil")
    |> post(priya, answers)

    conn
    |> login_as("Felipe Sere")
    |> get(present_link)
    |> html_response(200)
    |> has_title("Advice for Rabea Gleissner")
  end

  def has_title(html, expected_title) do
    assert html |> Floki.find("h1") |> Floki.text() == expected_title
    html
  end
end
