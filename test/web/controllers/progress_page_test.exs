defmodule Advisor.Web.ProgressPageTest do
  use Advisor.Web.ConnCase
  alias Advisor.Web.QuestionnaireProposal, as: Proposal
  alias Advisor.Web.Links
  alias Advisor.Core.{Creator, People}

  test "shows the progress filling in the questionnaires", %{conn: conn} do
    rabea = People.find_by(name: "Rabea Gleissner")
    felipe = People.find_by(name: "Felipe Sere")
    cj = People.find_by(name: "Chris Jordan")

    proposal = %Proposal{group_lead: 1,
                         requester: rabea.id,
                         advisors: [felipe.id, cj.id],
                         questions: [5, 6]}

    {_, progress_link} = proposal
                         |> Creator.create
                         |> Links.generate

    conn = conn
           |> assign(:user_id, felipe.id)
           |> get(progress_link)

    html = html_response(conn, 200)

    assert requester(html) =~ "Rabea Gleissner"
    assert advisors(html)  == ["Felipe Sere", "Chris Jordan"]
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
