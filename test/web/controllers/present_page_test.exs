defmodule AdvisorWeb.PresentPageTest do
  use AdvisorWeb.ConnCase
  import PageAssertions

  alias Advisor.Test.Support.{Sample, Users}

  test "it displays all four answers to the questionnaire", %{conn: conn} do
    q = Sample.questionnaire()
        |> Sample.answer("Priya Patil", all: "some answer")
        |> Sample.answer("Rabea Gleissner", all: "other answer")
        |> Sample.note("Rabea Gleissner", "some note")

    conn
    |> ThroughTheWeb.login_as("Felipe Sere")
    |> get(Routes.present_page_path(@endpoint, :index, q.id))
    |> html_response(200)
    |> has_title("Advice for Chris Jordan")
    |> has_advice_questions(2)
    |> has_answers(["some answer", "other answer"])
  end

  test "only the selected group lead can see the advice", %{conn: conn} do
    q = Sample.questionnaire()
        |> Sample.answer("Priya Patil", all: "some answer")
        |> Sample.answer("Rabea Gleissner", all: "other answer")

    Users.with("Jim Suchy")
    assert conn
           |> ThroughTheWeb.login_as("Jim Suchy")
           |> get(Routes.present_page_path(@endpoint, :index, q.id))
           |> redirected_to() == "/"
  end
end
