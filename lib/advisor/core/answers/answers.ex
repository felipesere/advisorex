defmodule Advisor.Core.Answers do
  alias Advisor.Repo
  alias Advisor.Core.Answer
  import Ecto.Query

  def store(params) do
    Repo.insert_all(Answer, all_answers(params), returning: true)
  end

  def all_answers(%{"id" => advice_request_id} = params) do
    Enum.reduce(params, [], fn({question_id, answer}, acc) ->
      case Integer.parse(question_id) do
        {id, ""} -> acc ++ [
          %{question_id: id,
            answer: answer,
            advice_request_id: advice_request_id}
        ]
        _ -> acc
      end
    end)
  end

  def gather(advisories) do
    Enum.map(advisories, &(find_with_advisory(&1)))
  end

  def find_with_advisory(advisory) do
    answers_from_advisory = from a in Answer,
      where: a.advice_request_id == ^advisory.id

    answers = Repo.all(answers_from_advisory)

    %{advisory: advisory, answers: answers}
  end

  def find(advisories) when is_list(advisories) do
    ids = advisories |> Enum.map(fn(x) -> x.advice_id end)

    Repo.all(from a in Answer, where: a.advice_request_id in ^ids)
  end
  def find(advisory) do
    answers_from_advisory = from a in Answer, where: a.advice_request_id == ^advisory.id

    Repo.all(answers_from_advisory)
  end
end
