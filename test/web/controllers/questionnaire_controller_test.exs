defmodule AdvisorWeb.QuestionnaireControllerTest do
  use AdvisorWeb.ConnCase

  alias Advisor.Test.Support.Sample
  alias Advisor.Core.{Answers, Advice, Questionnaire}

  test "will delete an entire questionnaire", %{conn: conn} do
    q = Sample.questionnaire(group_lead: "Felipe Sere", requester: "Rabea Gleissner",
                         advisors: ["Priya Patil"])
                         |> Sample.answer("Priya Patil", all: "foo")

    advisories = Advice.find_all(q)

    conn
    |> ThroughTheWeb.login_as("Felipe Sere")
    |> get(Routes.questionnaire_path(@endpoint, :delete, q.id))

    refute Questionnaire.find(q)
    assert [] == Answers.find(advisories)
    assert [] == Advice.find(advisories)
  end
end
