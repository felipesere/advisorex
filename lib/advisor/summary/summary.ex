defmodule Advisor.Summary do
  alias Advisor.{Person, Answer, Advice}
  alias Advisor.Questionnaire
  alias Advisor.Question
  alias Advisor.Repo
  import Ecto.Query

  def for_download(id) do
    [header(id) | content(id)]
  end

  defp content(id) do
    query =
      from(advice in Advice,
        join: q in Questionnaire,
        on: [id: advice.questionnaire_id],
        join: r in Person,
        on: [id: q.mentee_id],
        join: a in Person,
        on: [id: advice.advisor_id],
        join: answer in Answer,
        on: [advice_id: advice.id],
        where: advice.questionnaire_id == ^id,
        group_by: [a.email, answer.inserted_at, r.name],
        select: {answer.inserted_at, a.email, r.name, fragment("array_agg(answer)")}
      )

    query
    |> Repo.all()
    |> Enum.map(&(&1 |> Tuple.to_list() |> List.flatten()))
  end

  defp header(id) do
    id
    |> Questionnaire.questions()
    |> Question.phrases()
    |> prepend(["timestamp", "advisor", "mentee"])
  end

  defp prepend(head, tail), do: tail ++ head
end
