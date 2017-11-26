defmodule Advisor.Test.Support.Sample do
  alias Advisor.Core.Questionnaire
  alias Advisor.Core.Advice
  alias Advisor.Core.Question
  alias Advisor.Core.People
  alias Advisor.Repo
  alias Advisor.Test.Support.Users

  def questionnaire() do
    questionnaire(group_lead: "Felipe Sere", requester: "Chris Jordan", advisors: ["Rabea Gleissner", "Priya Patil"])
  end


  def questionnaire(group_lead: lead, requester: requester, advisors: advisors) do
    lead = Users.with(lead)
    requester = Users.with(requester)
    advisors = Users.with(advisors)

    ids = Question.store(["foo", "bar"])

    q = %Questionnaire{
      question_ids: ids,
      group_lead: lead.id,
      requester_id: requester.id,
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
    questionnaire
    |> Advice.find_all()
    |> Enum.map(fn(a) -> {a, People.find_by(id: a.advisor_id)} end)
    |> Enum.find(fn({_, p}) -> p.name == name end)
    |> elem(0)
  end

  def answer(questionnaire, name, [all: answer]) do
    advice = advice_from(questionnaire, name)
    questions = questionnaire.question_ids

    Enum.each(questions, fn(question) ->
      advice
      |> Ecto.build_assoc(:answers, %{answer: answer, question_id: question})
      |> Repo.insert!()
    end)

    questionnaire
  end
end
