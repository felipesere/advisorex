defmodule Advisor.Test.Support.Sample do
  alias Advisor.Core.Questionnaire
  alias Advisor.Core.Advice
  alias Advisor.Core.Question
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
end
