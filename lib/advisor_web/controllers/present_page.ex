defmodule AdvisorWeb.PresentPage do
  use AdvisorWeb, :controller
  alias Advisor.Core.{People, Questions, Questionnaire}

  # TODO: This bit here is attrociously long...
  def index(conn, %{"id" => questionnaire_id}) do
    questionnaire = Questionnaire.find(questionnaire_id)

    answered_questions = larger_method(questionnaire)

    requester = People.requester(questionnaire)
    render conn, "index.html", id: questionnaire_id,
                               request: requester,
                               answered_questions: answered_questions
  end

  defp larger_method(questionnaire) do
    questionnaire
    |> collect_answers()
    |> join(advisors(questionnaire))
    |> answered_questions(questionnaire)
  end

  defp collect_answers(%Questionnaire{advice: advisories}) do
    Enum.flat_map(advisories, &(&1.answers))
  end

  defp advisors(%Questionnaire{advice: advisories}) do
    for advisory <- advisories, into: %{}, do: {advisory.id, People.find_by(advisory)}
  end

  defp join(answers, advisors) do
    answers
    |> Enum.map(fn(answer) ->
      %{
        question_id: answer.question_id,
        answer_phrase: answer.answer,
        person: advisors[answer.advice_request_id]
      }
    end)
  end

  defp answered_questions(answers, %Questionnaire{question_ids: question_ids}) do
    questions = Questions.load(question_ids)

    answers
    |> Enum.group_by(&(&1.question_id), &(&1))
    |> Enum.map(fn({question_id, answers}) ->
      question = Enum.find(questions, &(&1.id == question_id))
      %{
        question_phrase: question.phrase,
        answers: answers
      }
    end)
  end
end
