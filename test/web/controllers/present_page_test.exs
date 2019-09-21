defmodule AdvisorWeb.PresentPageTest do
  use AdvisorWeb.ConnCase
  alias PageAssertions, as: It

  alias Advisor.Test.Support.{Sample, Users}

  test "it displays all four answers to the questionnaire", %{conn: conn} do
    %{id: id} =
      Sample.questionnaire()
      |> Sample.answer("Priya Patil", all: "some answer")
      |> Sample.answer("Rabea Gleissner", all: "other answer")

    conn
    |> Login.as("Felipe Sere")
    |> Visit.the(:questionnaire, id)
    |> It.has_title("Advice for Chris Jordan")
    |> It.has_advice_questions(2)
    |> It.has_answers(["some answer", "other answer"])
  end

  test "only the selected mentor can see the advice", %{conn: conn} do
    %{id: id} =
      Sample.questionnaire()
      |> Sample.answer("Priya Patil", all: "some answer")
      |> Sample.answer("Rabea Gleissner", all: "other answer")

    Users.with("Jim Suchy")

    assert conn
           |> Login.as("Jim Suchy")
           |> Visit.the!(:questionnaire, id)
           |> redirected_to() == "/"
  end
end
