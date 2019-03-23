defmodule AdvisorWeb.ProgressPageTest do
  use AdvisorWeb.ConnCase
  import PageAssertions
  alias Advisor.Test.Support.Sample

  test "shows which people have already completed questionnaires", %{conn: conn} do
    q =
      Sample.questionnaire()
      |> Sample.answer("Priya Patil", all: "some answer")

    conn
    |> ThroughTheWeb.login_as("Felipe Sere")
    |> get(Routes.progress_page_path(@endpoint, :index, q.id))
    |> html_response(200)
    |> has_completed_advice()
    |> has_continue_button_with("Waiting for further responses")
  end

  test "all completed advice questions", %{conn: conn} do
    q =
      Sample.questionnaire()
      |> Sample.answer("Priya Patil", all: "some answer")
      |> Sample.answer("Rabea Gleissner", all: "other answer")

    conn
    |> ThroughTheWeb.login_as("Felipe Sere")
    |> get(Routes.progress_page_path(@endpoint, :index, q.id))
    |> html_response(200)
    |> has_continue_button_with("We are good to go")
  end
end
