defmodule AdvisorWeb.ProgressPageTest do
  use AdvisorWeb.ConnCase
  alias PageAssertions, as: It
  alias Advisor.Test.Support.Sample

  test "shows which people have already completed questionnaires", %{conn: conn} do
    %{id: id} =
      Sample.questionnaire()
      |> Sample.answer("Priya Patil", all: "some answer")

    conn
    |> Login.as("Felipe Sere")
    |> Visit.the(:progress, id)
    |> It.has_completed_advice()
    |> It.has_continue_button_with("Waiting for further responses")
  end

  test "all completed advice questions", %{conn: conn} do
    %{id: id} =
      Sample.questionnaire()
      |> Sample.answer("Priya Patil", all: "some answer")
      |> Sample.answer("Rabea Gleissner", all: "other answer")

    conn
    |> Login.as("Felipe Sere")
    |> Visit.the(:progress, id)
    |> It.has_continue_button_with("We are good to go")
  end
end
