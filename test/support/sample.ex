defmodule Advisor.Test.Support.Sample do
  alias Advisor.Core.{Answer, Question, Questionnaire}
  alias Advisor.Repo
  alias Advisor.Test.Support.Users

  # TODO think about using Ecto.Multi here

  def questionnaire() do
    questionnaire(
      mentor: "Felipe Sere",
      mentee: "Chris Jordan",
      advisors: ["Rabea Gleissner", "Priya Patil"]
    )
  end

  def questionnaire(for: mentee) do
    questionnaire(
      mentor: "Felipe Sere",
      mentee: mentee,
      advisors: ["Rabea Gleissner", "Priya Patil"]
    )
  end

  def questionnaire(mentor: mentor, mentee: mentee, advisors: advisors) do
    mentor = Users.with(mentor)
    mentee = Users.with(mentee)
    advisors = Users.with(advisors)

    questionnaire =
      %Questionnaire{
        mentor_id: mentor.id,
        mentee: mentee,
        message: "This is a random message",
        questions: [%Question{phrase: "foo"}, %Question{phrase: "bar"}],
      }
      |> Repo.insert!()

    Enum.each(
      advisors,
      fn advisor ->
        questionnaire
        |> Ecto.build_assoc(:advice, %{mentee_id: mentee.id, advisor_id: advisor.id})
        |> Repo.insert!()
      end
    )

    Questionnaire.find(questionnaire.id)
  end

  def advice_from(questionnaire, name) do
    questionnaire.advice
    |> Enum.find(fn advice -> advice.advisor.name == name end)
  end

  def answer(questionnaire, all: answer) do
    advisories = questionnaire.advice
    questions = questionnaire.questions

    Enum.each(
      advisories,
      fn advice ->
        save_answers(questions, answer, advice.id)
      end
    )

    Questionnaire.find(questionnaire)
  end

  def answer(questionnaire, name, all: answer) do
    advice = advice_from(questionnaire, name)

    questionnaire.questions
    |> save_answers(answer, advice.id)

    Questionnaire.find(questionnaire)
  end

  defp save_answers(questions, answer, advice) do
    data =
      questions
      |> Enum.map(fn q -> %{question_id: q.id, answer: answer, advice_request_id: advice} end)

    Repo.insert_all(Answer, data)
  end
end
