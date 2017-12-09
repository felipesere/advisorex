defmodule AdvisorWeb.ProvideAdviceControllerTest do
  use AdvisorWeb.ConnCase
  import PageAssertions
  alias Advisor.Test.Support.Sample

  setup do
    questionnaire = Sample.questionnaire()
    advice = Sample.advice_from(questionnaire, "Rabea Gleissner")

    [advice: advice, questions: questionnaire.question_ids]
  end

  test "renders the form", %{conn: conn, advice: advice} do
    conn
    |> ThroughTheWeb.login_as("Rabea Gleissner")
    |> get(path_for(advice))
    |> html_response(200)
    |> has_header("Advice for Chris Jordan")
    |> has_message("This is a random message")
  end

  test "force login if incorrect advisor is authenticated", %{conn: conn, advice: advice} do
    assert conn
           |> ThroughTheWeb.login_as("Priya Patil")
           |> get(Routes.provide_advice_path(@endpoint, :index, advice.id))
           |> redirected_to() == "/"
  end

  test "answers questions", %{conn: conn, advice: advice, questions: questions} do
    payload = questions
              |> Enum.into(%{}, fn(id) -> {id, "some answer"} end)
              |> Map.put_new("id", advice.id)

    conn
    |> ThroughTheWeb.login_as("Rabea Gleissner")
    |> post(path_for(advice), payload)
    |> html_response(200)
    |> has_header("Thank you!")
  end

  def path_for(advice) do
    Routes.provide_advice_path(@endpoint, :create, advice.id)
  end
end
