defmodule AdvisorWeb.ProvideAdviceControllerTest do
  use AdvisorWeb.ConnCase
  alias Advisor.Test.Support.Proposal
  alias AdvisorWeb.Links
  alias Advisor.Core.Questionnaire.Creator
  import PageAssertions

  setup do
    {links, progress, _} = Proposal.basic()
                           |> Proposal.with_advisors(["Felipe Sere", "Chris Jordan"])
                           |> Proposal.with_message("Clever message")
                           |> Proposal.build("Rabea Gleissner")
                           |> Creator.create
                           |> Links.generate

    [links: links, progress: progress]
  end

  test "renders the form", %{conn: conn, links: links} do
    felipes_advice = advisory_for(links, "Felipe Sere")

    conn
    |> ThroughTheWeb.login_as("Felipe Sere")
    |> get(felipes_advice)
    |> html_response(200)
    |> has_header("Advice for Rabea Gleissner")
    |> has_message("Clever message")
  end

  test "force login if incorrect advisor is authenticated", %{conn: conn, links: links} do
    felipes_advice_link = advisory_for(links, "Felipe Sere")

    conn = conn
           |> ThroughTheWeb.login_as("Rabea Gleissner")
           |> get(felipes_advice_link)

    assert conn |> redirected_to() == "/"
    assert conn.cookies["target"] == felipes_advice_link
  end

  test "renders thank you page", %{conn: conn, links: links} do
    [%{link: link} | _] = links

    conn
    |> ThroughTheWeb.login_as("Felipe Sere")
    |> post(link)
    |> html_response(200)
    |> has_header("Thank you!")
  end

  def advisory_for(links, name) do
    links
    |> Enum.find(&(&1.person.name == name))
    |> Map.fetch!(:link)
  end
end
