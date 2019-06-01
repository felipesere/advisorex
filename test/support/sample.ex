defmodule Advisor.Test.Support.Sample do
  alias Advisor.{Advice, Questionnaire}
  alias Advisor.Test.Support.Users

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

    Questionnaire.Creator.create(%{
      mentee: mentee.id,
      mentor: mentor.id,
      message: "This is a random message",
      questions: ["foo", "bar"],
      advisors: Enum.map(advisors, fn a -> a.id end)
    })
  end

  def advice_from(questionnaire, name) do
    questionnaire.advice
    |> Enum.find(fn advice -> advice.advisor.name == name end)
  end

  def answer(questionnaire, all: answer) do
    advisories = questionnaire.advice
    questions = questionnaire.questions

    Enum.each(advisories, fn advice -> save_answers(questions, answer, advice) end)

    Questionnaire.find(questionnaire)
  end

  def answer(questionnaire, name, all: answer) do
    advice = advice_from(questionnaire, name)

    questionnaire.questions
    |> save_answers(answer, advice)

    Questionnaire.find(questionnaire)
  end

  defp save_answers(questions, answer, advice) do
    answered = Enum.into(questions, %{}, fn q -> {q.id, answer} end)
    Advice.save_answers(advice, answered)
  end
end
