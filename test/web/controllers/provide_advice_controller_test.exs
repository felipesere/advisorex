defmodule AdvisorWeb.ProvideAdviceControllerTest do
  use AdvisorWeb.ConnCase
  alias PageAssertions, as: It
  alias Advisor.Test.Support.Sample
  alias Advisor.Core.Answers

  setup do
    questionnaire = Sample.questionnaire()
    advice = Sample.advice_from(questionnaire, "Rabea Gleissner")

    [advice: advice, questions: questionnaire.question_ids]
  end

  test "renders the form", %{conn: conn, advice: advice} do
    conn
    |> Login.as("Rabea Gleissner")
    |> Visit.page_for(advice)
    |> It.has_header("Advice for Chris Jordan")
    |> It.has_message("This is a random message")
  end

  test "force login if incorrect advisor is authenticated", %{conn: conn, advice: advice} do
    assert conn
           |> Login.as("Priya Patil")
           |> Visit.the(advice)
           |> redirected_to() == "/"
  end

  test "answers questions", %{conn: conn, advice: advice, questions: questions} do
    # something like 'create an answer'
    payload = Enum.into(questions, %{"id" => advice.id}, fn id -> {id, "some answer"} end)

    conn
    |> Login.as("Rabea Gleissner")
    |> Submit.answers!(payload, for: advice)
    |> It.has_header("Thank you!")
  end

  test "can't answer twice", %{conn: conn} do
    questionnaire =
      Sample.questionnaire()
      |> Sample.answer(all: "abc")

    advice = Sample.advice_from(questionnaire, "Rabea Gleissner")

    payload =
      questionnaire.question_ids
      |> Enum.into(%{}, fn id -> {id, "xyz"} end)
      |> Map.put_new("id", advice.id)

    conn
    |> Login.as("Rabea Gleissner")
    |> Submit.answers(payload, for: advice)

    assert answers_for(questionnaire, advice) == ["abc"]
  end

  defp answers_for(questionnaire, %Advisor.Core.Advice{id: id}) do
    questionnaire
    |> Answers.find()
    |> Enum.filter(fn answer -> answer.advice_request_id == id end)
    |> Enum.map(fn answer -> answer.answer end)
    |> Enum.uniq()
  end
end
