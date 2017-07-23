defmodule Advisor.Core.Summary do
  alias Advisor.Core.{Person, Answer, Advice}
  alias Advisor.Core.{Questions, Questionnaire}
  alias Advisor.Repo
  import Ecto.Query

  def for_download(id) do
    query = from advice in Advice,
               join: r in Person, on: [id: advice.requester_id],
               join: a in Person, on: [id: advice.advisor_id],
               join: answer in Answer, on: [advice_request_id: advice.id],
               where: advice.questionnaire_id == ^id,
               group_by: [a.email, answer.inserted_at, r.name],
               select: {answer.inserted_at, a.email, r.name, fragment("array_agg(answer)")}

    content = query
              |> Repo.all()
              |> Enum.map(fn({ts, adv, req, answers}) -> [ts, adv, req] ++ answers end)

    questions = id
                |> Questionnaire.questions()
                |> Questions.find()
                |> Questions.phrases()
    header = ["timestamp", "advisor", "requester"] ++ questions

    [header | content]
  end
end
