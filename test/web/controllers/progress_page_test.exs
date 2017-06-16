defmodule Advisor.Web.ProgressPageTest do
  use Advisor.Web.ConnCase
  alias Advisor.Web.QuestionnaireProposal, as: Proposal
  alias Advisor.Web.Links
  alias Advisor.Core.Creator

  @sample_questions [5, 6]

  test "shows the progress filling in the questionnaires", %{conn: conn} do
    proposal = Proposal.build(for: "Rabea Gleissner",
                              advisors: ["Chris Jordan", "Priya Patil"],
                              group_lead: "Felipe Sere",
                              questions: @sample_questions)

    {_, progress_link} = proposal
                         |> Creator.create
                         |> Links.generate

    conn
    |> login_as("Felipe Sere")
    |> get(progress_link)
    |> html_response(200)
    |> has_requester("Rabea Gleissner")
    |> has_advisors(["Chris Jordan", "Priya Patil"])
  end

  def has_requester(html, requester_name) do
    assert requester(html) =~ requester_name
    html
  end

  def has_advisors(html, advisors_names) do
    assert advisors(html) == advisors_names
    html
  end

  def requester(html) do
    html
    |> Floki.find(".progress-requester")
    |> Floki.text
  end

  def advisors(html) do
    html
    |> Floki.find(".advisor")
    |> Enum.map(&Floki.text/1)
  end
end
