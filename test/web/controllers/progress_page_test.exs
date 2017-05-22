defmodule Advisor.Web.ProgressPageTest do
  use Advisor.Web.ConnCase
  alias Advisor.Web.QuestionnaireProposal, as: Proposal
  alias Advisor.Web.Links
  alias Advisor.Core.{Creator, People}

  test "shows the progress filling in the questionnaires", %{conn: conn} do
    requester = People.find_by name: "Rabea Gleissner"
    advisors = [People.find_by(name: "Felipe Sere"), People.find_by(name: "Chris Jordan")]
    proposal = %Proposal{group_lead: 1,
                         requester: requester.id,
                         advisors: Enum.map(advisors, &(&1.id)),
                         questions: [5,6]}

    {_, progress_link} = Creator.create(proposal) |> Links.generate

    conn = conn |> get(progress_link)
    html = html_response(conn, 200)

    assert html |> Floki.find(".progress-requester") |> Floki.text =~ "Rabea Gleissner"
    assert advisors(html) == ["Felipe Sere", "Chris Jordan"]
  end

  def advisors(html) do
    html
    |> Floki.find(".advisor")
    |> Enum.map(&Floki.text/1)
  end
end
