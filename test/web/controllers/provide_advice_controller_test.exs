defmodule AdvisorWeb.ProvideAdviceControllerTest do
  use AdvisorWeb.ConnCase
  alias PageAssertions, as: It
  alias Advisor.Test.Support.Sample

  setup do
    questionnaire = Sample.questionnaire()

    [questionnaire: questionnaire, questions: questionnaire.questions]
  end

  test "renders the form", %{conn: conn, questionnaire: questionnaire} do
    conn
    |> Login.as("Rabea Gleissner")
    |> Visit.provide_advice_to!(questionnaire)
    |> It.has_header("Advice for Chris Jordan")
    |> It.has_message("This is a random message")
  end

  test "force login if incorrect advisor is authenticated", %{
    conn: conn,
    questionnaire: questionnaire
  } do
    nick = Advisor.Test.Support.Users.with("Nick Dyer")

    assert conn
           |> Login.as(nick)
           |> Visit.provide_advice_to(questionnaire)
           |> redirected_to() == "/"
  end

  test "answers questions", %{conn: conn, questions: questions, questionnaire: questionnaire} do
    # something like 'create an answer'
    payload =
      questions |> Enum.into(%{"id" => questionnaire.id}, fn q -> {q.id, "some answer"} end)

    conn
    |> Login.as("Rabea Gleissner")
    |> Submit.answers!(payload, for: questionnaire)
    |> It.has_header("Thank you!")

    assert answers_from("Rabea Gleissner", in: questionnaire) == ["some answer"]
  end

  test "can't answer twice", %{conn: conn} do
    questionnaire =
      Sample.questionnaire()
      |> Sample.answer(all: "abc")

    payload =
      questionnaire.questions |> Enum.into(%{"id" => questionnaire.id}, fn q -> {q.id, "xzy"} end)

    conn
    |> Login.as("Rabea Gleissner")
    |> Submit.answers(payload, for: questionnaire)

    assert answers_from("Rabea Gleissner", in: questionnaire) == ["abc"]
  end

  defp answers_from(advisor_name, in: questionnaire) do
    questionnaire
    |> Advisor.Core.Questionnaire.find()
    |> Map.fetch!(:advice)
    |> Enum.find(fn advice -> advice.advisor.name == advisor_name end)
    |> Map.fetch!(:answers)
    |> Enum.map(fn answer -> answer.answer end)
    |> Enum.uniq()
  end
end
