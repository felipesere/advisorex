defmodule Advisor.Test.Support.Sample do
  alias Advisor.Core.Questionnaire
  alias Advisor.Core.Advice
  alias Advisor.Core.Question
  alias Advisor.Core.People
  alias Advisor.Core.Answer
  alias Advisor.Repo
  alias Advisor.Test.Support.Users

  def questionnaire() do
    [felipe, cj, rabea, priya] = Users.with(["Felipe Sere", "Chris Jordan", "Rabea Gleissner", "Priya Patil"])

    ids = Question.store(["foo", "bar"])

    q = %Questionnaire{
      question_ids: ids,
      group_lead: felipe.id,
      requester_id: cj.id,
      message: "This is a random message"
    }
    |> Repo.insert!()

    q
    |> Ecto.build_assoc(:advice, %{requester_id: cj.id, advisor_id: rabea.id})
    |> Repo.insert!()

    q
    |> Ecto.build_assoc(:advice, %{requester_id: cj.id, advisor_id: priya.id})
    |> Repo.insert!()

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
    person = People.find_by(name: name)
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
