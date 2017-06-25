defmodule Advisor.Core.Answers do
  alias Advisor.Repo
  alias Advisor.Core.Answer
  import Ecto.Query

  @into_list []

  def store(params) do
    Repo.insert_all(Answer, all_answers_in(params), returning: true)
  end

  def all_answers_in(%{"id" => advice_request_id} = params) do
    params
    |> Enum.reduce(@into_list, &to_answer/2)
    |> add(advice_request_id)
  end

  defp add(answers, advice_request_id) when is_list(answers) do
    answers
    |> Enum.map(&(Map.put(&1, :advice_request_id, advice_request_id)))
  end

  defp to_answer({question_id, answer}, answers) do
    case number?(question_id) do
      :not_a_number -> answers
      num -> [%{question_id: num, answer: answer} | answers]
    end
  end

  defp number?(number) do
    case Integer.parse(number) do
      {num, ""} -> num
      _ -> :not_a_number
    end
  end

  def gather(advisories) do
    Enum.map(advisories, &(find_with_advisory(&1)))
  end

  defp find_with_advisory(advisory) do
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
