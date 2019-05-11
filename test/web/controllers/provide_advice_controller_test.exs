defmodule AdvisorWeb.ProvideAdviceControllerTest do
  use AdvisorWeb.ConnCase
  import PageAssertions
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
    |> get(path_for(advice))
    |> html_response(200)
    |> has_header("Advice for Chris Jordan")
    |> has_message("This is a random message")
  end

  test "force login if incorrect advisor is authenticated", %{conn: conn, advice: advice} do
    assert conn
           |> Login.as("Priya Patil")
           |> get(Routes.provide_advice_path(@endpoint, :index, advice.id))
           |> redirected_to() == "/"
  end

  test "answers questions", %{conn: conn, advice: advice, questions: questions} do
    payload =
      questions
      |> Enum.into(%{}, fn id -> {id, "some answer"} end)
      |> Map.put_new("id", advice.id)

    conn
    |> Login.as("Rabea Gleissner")
    |> post(path_for(advice), payload)
    |> html_response(200)
    |> has_header("Thank you!")
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
    |> post(path_for(advice), payload)

    answers =
      questionnaire
      |> Answers.find()
      |> Enum.filter(fn answer -> answer.advice_request_id == advice.id end)
      |> Enum.map(fn answer -> answer.answer end)
      |> Enum.uniq()

    assert answers == ["abc"]
  end

  def path_for(advice) do
    Routes.provide_advice_path(@endpoint, :create, advice.id)
  end
end
