defmodule Advisor.Core.Summary do
  alias Advisor.Core.{Person, Answer, Advice}
  alias Advisor.Core.Questionnaire
  alias Advisor.Core.Questions
  alias Advisor.Repo
  import Ecto.Query

  def for_download(id) do
    [header(id) | content(id)]
  end

  defp content(id) do
    query = from advice in Advice,
      join: r in Person, on: [id: advice.requester_id],
      join: a in Person, on: [id: advice.advisor_id],
      join: answer in Answer, on: [advice_request_id: advice.id],
      where: advice.questionnaire_id == ^id,
      group_by: [a.email, answer.inserted_at, r.name],
      select: {answer.inserted_at, a.email, r.name, fragment("array_agg(answer)")}

    query
    |> Repo.all()
    |> Enum.map(&(&1 |> Tuple.to_list() |> List.flatten()))
  end

  defp header(id) do
    id
    |> Questionnaire.questions()
    |> Questions.load()
    |> Questions.phrases()
    |> prepend(["timestamp", "advisor", "requester"])
  end

  defp prepend(head, tail), do: tail ++ head
end
