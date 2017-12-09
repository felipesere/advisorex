defmodule Advisor.Test.Support.Sample do
  alias Advisor.Core.{Answer, Question, Questionnaire}
  alias Advisor.Repo
  alias Advisor.Test.Support.Users


  # TODO think about using Ecto.Multi here

  def questionnaire() do
    questionnaire(group_lead: "Felipe Sere", requester: "Chris Jordan", advisors: ["Rabea Gleissner", "Priya Patil"])
  end

  def questionnaire([for: requester]) do
    questionnaire(group_lead: "Felipe Sere", requester: requester, advisors: ["Rabea Gleissner", "Priya Patil"])
  end

  def questionnaire(group_lead: lead, requester: requester, advisors: advisors) do
    lead = Users.with(lead)
    requester = Users.with(requester)
    advisors = Users.with(advisors)

    ids = Question.store(["foo", "bar"])

    q = %Questionnaire{
      question_ids: ids,
      group_lead_id: lead.id,
      requester: requester,
      message: "This is a random message"
    }
    |> Repo.insert!()

    Enum.each(advisors, fn(advisor) ->
      q
      |> Ecto.build_assoc(:advice, %{requester_id: requester.id, advisor_id: advisor.id})
      |> Repo.insert!()
    end)

    Questionnaire.find(q.id)
  end

  def advice_from(questionnaire, name) do
    questionnaire.advice
    |> Enum.find(fn(advice) -> advice.advisor.name == name end)
  end

  def answer(questionnaire, [all: answer]) do
    advisories = questionnaire.advice
    questions = questionnaire.question_ids

    Enum.each(advisories, fn(advice) ->
      save_answers(questions, answer, advice.id)
    end)
    Questionnaire.find(questionnaire)
  end

  def answer(questionnaire, name, [all: answer]) do
    advice = advice_from(questionnaire, name)
    questions = questionnaire.question_ids
    save_answers(questions, answer, advice.id)
    Questionnaire.find(questionnaire)
  end

  defp save_answers(questions, answer, advice) do
    data = questions
           |> Enum.map(fn(q) -> %{question_id: q, answer: answer, advice_request_id: advice} end)

    Repo.insert_all(Answer, data)
  end
end
