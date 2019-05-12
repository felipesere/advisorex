defmodule AdvisorWeb.PresentPage do
  use AdvisorWeb, :controller
  alias Advisor.Core.{Question, Questionnaire}
  alias AdvisorWeb.Authentication.User

  plug AdvisorWeb.Authentication.Gatekeeper, only: :mentors

  def index(conn, %{"id" => questionnaire_id}) do
    user = User.of(conn)
    questionnaire = Questionnaire.find(questionnaire_id)

    if questionnaire.mentor == user do
      answered_questions = answers_per_question(questionnaire)

      render(conn, "index.html",
        id: questionnaire_id,
        request: questionnaire.mentee,
        answered_questions: answered_questions
      )
    else
      conn |> redirect(to: "/")
    end
  end

  defp answers_per_question(questionnaire) do
    questionnaire
    |> collect_answers()
    |> join(advisors(questionnaire))
    |> answered_questions(questionnaire)
  end

  defp collect_answers(%Questionnaire{advice: advisories}) do
    Enum.flat_map(advisories, & &1.answers)
  end

  defp advisors(%Questionnaire{advice: advisories}) do
    for advice <- advisories, into: %{}, do: {advice.id, advice.advisor}
  end

  defp join(answers, advisors) do
    answers
    |> Enum.map(fn answer ->
      %{
        question_id: answer.question_id,
        answer_phrase: answer.answer,
        person: advisors[answer.advice_request_id]
      }
    end)
  end

  defp answered_questions(answers, %Questionnaire{question_ids: question_ids}) do
    questions = Question.load(question_ids)

    answers
    |> Enum.group_by(& &1.question_id, & &1)
    |> Enum.map(fn {question_id, answers} ->
      question = Enum.find(questions, &(&1.id == question_id))

      %{
        question_phrase: question.phrase,
        answers: answers
      }
    end)
  end
end
