defmodule AdvisorWeb.ProvideAdviceControllerTest do
  use AdvisorWeb.ConnCase
  alias AdvisorWeb.QuestionnaireProposal, as: Proposal
  alias AdvisorWeb.Links
  alias Advisor.Core.Questionnaire.Creator
  import PageAssertions

  setup do
    {links, progress, _} = create_questionnaire(for: "Rabea Gleissner",
                                                advisors: ["Felipe Sere", "Chris Jordan"],
                                                group_lead: "Jim Suchy",
                                                questions: [5, 6])

    [links: links, progress: progress]
  end

  test "renders the form", %{conn: conn, links: links} do
    felipes_advice = advisory_for(links, "Felipe Sere")

    conn
    |> ThroughTheWeb.login_as("Felipe Sere")
    |> get(felipes_advice)
    |> html_response(200)
    |> has_header("Advice for Rabea Gleissner")
  end

  test "force login if incorrect advisor is authenticated", %{conn: conn, links: links} do
    felipes_advice_link = advisory_for(links, "Felipe Sere")

    conn = conn
           |> ThroughTheWeb.login_as("Rabea Gleissner")
           |> get(felipes_advice_link)

    assert conn |> redirected_to() == "/"
    assert conn.cookies["target"] == felipes_advice_link
  end

  test "renders thank you page", %{conn: conn} do
    conn
    |> ThroughTheWeb.login_as("Felipe Sere")
    |> post("/provide/1")
    |> html_response(200)
    |> has_header("Thank you!")
  end

  def create_questionnaire(opts) do
    opts
    |> Proposal.build
    |> Creator.create
    |> Links.generate
  end

  def advisory_for(links, name) do
    links
    |> Enum.find(&(&1.person.name == name))
    |> Map.fetch!(:link)
  end
end
