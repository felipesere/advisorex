defmodule Advisor.Web.ProvideAdviceControllerTest do
  use Advisor.Web.ConnCase
  alias Advisor.Web.QuestionnaireProposal, as: Proposal
  alias Advisor.Web.Links
  alias Advisor.Core.Creator

  test "renders the form", %{conn: conn} do
    {links, _} = create_questionnaire(for: "Rabea Gleissner",
                                      advisors: ["Felipe Sere", "Chris Jordan"],
                                      group_lead: "Jim Suchy",
                                      questions: [5, 6])

    felipes_advice = advisory_for(links, "Felipe Sere")

    conn
    |> login_as("Felipe Sere")
    |> get(felipes_advice)
    |> html_response(200)
    |> has_header("Advice for Rabea Gleissner")
  end

  def has_header(html, header) do
    value = html
            |> Floki.find("h1")
            |> Floki.text

    assert value ==  header
  end

  test "renders thank you page", %{conn: conn} do
    conn
    |> login_as("Felipe Sere")
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
