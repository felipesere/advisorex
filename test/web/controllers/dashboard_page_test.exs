defmodule Advisor.Web.DashboardPageTest do
  use Advisor.Web.ConnCase
  import PageAssertions

  alias Advisor.Web.QuestionnaireProposal, as: Proposal
  alias Advisor.Core.Questionnaire.Creator

  @group_lead "Felipe Sere"

  def advice_for(person, advisors) do
      proposal = Proposal.build(for: person,
                     advisors: advisors,
                     group_lead: @group_lead,
                     questions: [1, 2])
    Creator.create(proposal)
  end

  test "it shows a section for group leads", %{conn: conn} do
    advice_for("Rabea Gleissner", ["Priya Patil", "Sarah Johnston"])
    advice_for("Chris Jordan", ["Nick Dyer", "Jim Suchy"])

    conn
    |> login_as(@group_lead)
    |> get("/dashboard")
    |> html_response(200)
    |> has_title("Hello Felipe Sere!")
    |> advice_open_for("Rabea Gleissner")
    |> advice_open_for("Chris Jordan")
  end

  test "it shows the advice you still have to give", %{conn: conn} do
    advice_for("Rabea Gleissner", ["Priya Patil", "Sarah Johnston"])
    advice_for("Chris Jordan", ["Priya Patil", "Jim Suchy"])

    conn
    |> login_as("Priya Patil")
    |> get("/dashboard")
    |> html_response(200)
    |> advice_needed_for("Rabea Gleissner")
    |> advice_needed_for("Chris Jordan")
  end

  test "it shows who still has to give you advice", %{conn: conn} do
    advice_for("Rabea Gleissner", ["Priya Patil", "Sarah Johnston"])

    conn
    |> login_as("Rabea Gleissner")
    |> get("/dashboard")
    |> html_response(200)
    |> still_has_to_give_me_advice("Priya Patil")
    |> still_has_to_give_me_advice("Sarah Johnston")
  end

  def still_has_to_give_me_advice(html, advisor) do
    assert html
            |> Floki.find(".status-of-my-advisors > p")
            |> Enum.map(&Floki.text/1)
            |> Enum.member?(advisor)
    html
  end

  def advice_needed_for(html, requester) do
    assert html
            |> Floki.find(".open-advice-requets > p")
            |> Enum.map(&Floki.text/1)
            |> Enum.member?(requester)

    html
  end

  def advice_open_for(html, requester) do
    advice = fn(text) -> text =~ "Advice for " <> requester end
    assert html
            |> advice_text
            |> Enum.any?(advice)
    html
  end

  def no_advice_open_for(html, requester) do
    advice = fn(text) -> text =~ "Advice for " <> requester end
    assert html
            |> advice_text
            |> Enum.none?(advice)
    html
  end

  defp advice_text(html) do
    html
    |> Floki.find("li > p")
    |> Enum.map(&Floki.text/1)
  end
end
