defmodule AdvisorWeb.DashboardPageTest do
  use AdvisorWeb.ConnCase
  import PageAssertions

  alias Advisor.Test.Support.{Sample, Users}
  alias Advisor.Core.People

  @group_lead "Felipe Sere"

  test "you can only have a single questionnaire open", %{conn: conn} do
    Sample.questionnaire(
      group_lead: "Jim Suchy",
      requester: "Felipe Sere",
      advisors: ["Priya Patil"]
    )

    conn
    |> ThroughTheWeb.login_as(@group_lead)
    |> get("/dashboard")
    |> html_response(200)
    |> has_no_link("Request advice for yourself")
  end

  test "it shows a section for group leads", %{conn: conn} do
    Sample.questionnaire(
      group_lead: @group_lead,
      requester: "Rabea Gleissner",
      advisors: ["Priya Patil", "Sarah Johnston"]
    )

    Sample.questionnaire(
      group_lead: @group_lead,
      requester: "Chris Jordan",
      advisors: ["Nick Dyer", "Jim Suchy"]
    )

    conn
    |> ThroughTheWeb.login_as(@group_lead)
    |> get("/dashboard")
    |> html_response(200)
    |> has_title("Hello Felipe Sere!")
    |> advice_open_for("Rabea Gleissner")
    |> advice_open_for("Chris Jordan")
  end

  test "it shows the advice you still have to give", %{conn: conn} do
    Sample.questionnaire(
      group_lead: @group_lead,
      requester: "Rabea Gleissner",
      advisors: ["Priya Patil"]
    )

    Sample.questionnaire(
      group_lead: @group_lead,
      requester: "Chris Jordan",
      advisors: ["Priya Patil"]
    )

    conn
    |> ThroughTheWeb.login_as("Priya Patil")
    |> get("/dashboard")
    |> html_response(200)
    |> advice_needed_for("Rabea Gleissner")
    |> advice_needed_for("Chris Jordan")
  end

  test "it doesn't show advice you have already given", %{conn: conn} do
    Sample.questionnaire(
      group_lead: @group_lead,
      requester: "Chris Jordan",
      advisors: ["Priya Patil"]
    )
    |> Sample.answer("Priya Patil", all: "someting")

    conn
    |> ThroughTheWeb.login_as("Priya Patil")
    |> get("/dashboard")
    |> html_response(200)
    |> no_advice_needed_for("Rabea Gleissner")
  end

  test "it shows who still has to give you advice", %{conn: conn} do
    Sample.questionnaire(
      group_lead: @group_lead,
      requester: "Rabea Gleissner",
      advisors: ["Priya Patil", "Sarah Johnston"]
    )

    conn
    |> ThroughTheWeb.login_as("Rabea Gleissner")
    |> get("/dashboard")
    |> html_response(200)
    |> still_has_to_give_me_advice("Priya Patil")
    |> still_has_to_give_me_advice("Sarah Johnston")
  end

  test "it allows you to become a group lead", %{conn: conn} do
    Users.with("Rabea Gleissner")

    assert conn
           |> ThroughTheWeb.login_as("Rabea Gleissner")
           |> post("/dashboard/settings", %{"person" => %{"is_group_lead" => "true"}})
           |> redirected_to() == "/dashboard"

    assert People.find_by(name: "Rabea Gleissner").is_group_lead
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

  def no_advice_needed_for(html, requester) do
    refute html
           |> Floki.find(".open-advice-requets > p")
           |> Enum.map(&Floki.text/1)
           |> Enum.member?(requester)

    html
  end

  def advice_open_for(html, requester) do
    advice = fn text -> text =~ "Advice for " <> requester end

    assert html
           |> Floki.find("li > p")
           |> Enum.map(&Floki.text/1)
           |> Enum.any?(advice)

    html
  end
end
