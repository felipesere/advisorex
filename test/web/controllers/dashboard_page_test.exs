defmodule AdvisorWeb.DashboardPageTest do
  use AdvisorWeb.ConnCase
  import PageAssertions

  alias Advisor.Test.Support.{Sample, Users}
  alias Advisor.People

  @mentor "Felipe Sere"

  test "you can only have a single questionnaire open", %{conn: conn} do
    Sample.questionnaire(
      mentor: "Jim Suchy",
      mentee: "Felipe Sere",
      advisors: ["Priya Patil"]
    )

    conn
    |> Login.as(@mentor)
    |> get("/dashboard")
    |> html_response(200)
    |> has_no_link("Request advice for yourself")
  end

  test "it shows a section for mentors", %{conn: conn} do
    Sample.questionnaire(
      mentor: @mentor,
      mentee: "Rabea Gleissner",
      advisors: ["Priya Patil", "Sarah Johnston"]
    )

    Sample.questionnaire(
      mentor: @mentor,
      mentee: "Chris Jordan",
      advisors: ["Nick Dyer", "Jim Suchy"]
    )

    conn
    |> Login.as(@mentor)
    |> get("/dashboard")
    |> html_response(200)
    |> has_title("Hello Felipe Sere!")
    |> advice_open_for("Rabea Gleissner")
    |> advice_open_for("Chris Jordan")
  end

  test "it shows the advice you still have to give", %{conn: conn} do
    Sample.questionnaire(
      mentor: @mentor,
      mentee: "Rabea Gleissner",
      advisors: ["Priya Patil"]
    )

    Sample.questionnaire(
      mentor: @mentor,
      mentee: "Chris Jordan",
      advisors: ["Priya Patil"]
    )

    conn
    |> Login.as("Priya Patil")
    |> get("/dashboard")
    |> html_response(200)
    |> advice_needed_for("Rabea Gleissner")
    |> advice_needed_for("Chris Jordan")
  end

  test "it doesn't show advice you have already given", %{conn: conn} do
    Sample.questionnaire(
      mentor: @mentor,
      mentee: "Chris Jordan",
      advisors: ["Priya Patil"]
    )
    |> Sample.answer("Priya Patil", all: "someting")

    conn
    |> Login.as("Priya Patil")
    |> get("/dashboard")
    |> html_response(200)
    |> no_advice_needed_for("Rabea Gleissner")
  end

  test "it shows who still has to give you advice", %{conn: conn} do
    Sample.questionnaire(
      mentor: @mentor,
      mentee: "Rabea Gleissner",
      advisors: ["Priya Patil", "Sarah Johnston"]
    )

    conn
    |> Login.as("Rabea Gleissner")
    |> get("/dashboard")
    |> html_response(200)
    |> still_has_to_give_me_advice("Priya Patil")
    |> still_has_to_give_me_advice("Sarah Johnston")
  end

  test "it allows you to become a mentor", %{conn: conn} do
    Users.with("Rabea Gleissner")

    assert conn
           |> Login.as("Rabea Gleissner")
           |> post("/dashboard/settings", %{"person" => %{"is_mentor" => "true"}})
           |> redirected_to() == "/dashboard"

    assert People.find_by(name: "Rabea Gleissner").is_mentor
  end

  def still_has_to_give_me_advice(html, advisor) do
    assert html
           |> Floki.find(".status-of-my-advisors > p")
           |> Enum.map(&Floki.text/1)
           |> Enum.member?(advisor)

    html
  end

  def advice_needed_for(html, mentee) do
    assert html
           |> Floki.find(".open-advice-requests > p")
           |> Enum.map(&Floki.text/1)
           |> Enum.member?(mentee)

    html
  end

  def no_advice_needed_for(html, mentee) do
    refute html
           |> Floki.find(".open-advice-requests > p")
           |> Enum.map(&Floki.text/1)
           |> Enum.member?(mentee)

    html
  end

  def advice_open_for(html, mentee) do
    advice = fn text -> text =~ "Advice for " <> mentee end

    assert html
           |> Floki.find("li > p")
           |> Enum.map(&Floki.text/1)
           |> Enum.any?(advice)

    html
  end
end
