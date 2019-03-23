defmodule AdvisorWeb.QuestionnaireControllerTest do
  use AdvisorWeb.ConnCase

  alias Advisor.Test.Support.Sample
  alias Advisor.Core.{Answers, Advice, Questionnaire}

  test "will delete an entire questionnaire", %{conn: conn} do
    questionnaire =
      Sample.questionnaire(
        group_lead: "Felipe Sere",
        requester: "Rabea Gleissner",
        advisors: ["Priya Patil"]
      )
      |> Sample.answer("Priya Patil", all: "foo")

    conn
    |> ThroughTheWeb.login_as("Felipe Sere")
    |> get(Routes.questionnaire_path(@endpoint, :delete, questionnaire.id))

    refute Questionnaire.find(questionnaire)
    assert [] == Answers.find(questionnaire)
    assert [] == Advice.find(questionnaire)
  end
end
