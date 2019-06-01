defmodule AdvisorWeb.QuestionnaireControllerTest do
  use AdvisorWeb.ConnCase

  alias Advisor.Test.Support.Sample
  alias Advisor.Questionnaire

  test "will delete an entire questionnaire", %{conn: conn} do
    questionnaire =
      Sample.questionnaire(
        mentor: "Felipe Sere",
        mentee: "Rabea Gleissner",
        advisors: ["Priya Patil"]
      )
      |> Sample.answer("Priya Patil", all: "foo")

    conn
    |> Login.as("Felipe Sere")
    |> get(Routes.questionnaire_path(@endpoint, :delete, questionnaire.id))

    refute Questionnaire.find(questionnaire)
  end
end
