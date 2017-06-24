defmodule Advisor.Web.PresentPage do
  use Advisor.Web, :controller
  alias Advisor.Core.{People, QuestionnaireFinder, AdviceFinder, AnswerFinder}
  alias Advisor.Core.Questions

  def index(conn, %{"id" => id}) do
    %{question_ids: question_ids} = questionnaire = QuestionnaireFinder.find(id)
    advisories = AdviceFinder.gather_for_questionnaire(id)
    advisor_for = for advisory <- advisories, into: %{}, do: {advisory.id, People.find_by(advisory)}
    answers = Enum.flat_map(advisories, &AnswerFinder.find/1)
    questions = Questions.find(question_ids)

    answered_questions = Enum.map(questions, fn(question) ->
      answers = answers
          |> Enum.filter(fn(answer) -> question.id == answer.question_id end)
          |> Enum.map(fn(answer) -> %{
            person: advisor_for[answer.advice_request_id],
            answer_phrase: answer.answer}
          end)

      %{question_phrase: question.phrase, answers: answers}
    end)

    requester = People.find_requester(questionnaire)
    render conn, "index.html", id: id, request: requester, answered_questions: answered_questions
  end
end
