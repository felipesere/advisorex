defmodule Advisor.Core.Answers do
  alias Advisor.Repo
  alias Advisor.Core.Answer
  alias Advisor.Core.Advice
  import Ecto.Query

  @into_list []

  def store(params) do
    Repo.insert_all(Answer, all_answers_in(params), returning: true) |> IO.inspect
  end

  def all_answers_in(%{"id" => advice_request_id} = params) do
    params
    |> Enum.reduce(@into_list, &to_answer/2)
    |> add(advice_request_id)
  end

  defp to_answer({question_id, answer}, answers) do
    [%{question_id: question_id, answer: answer} | answers]
  end

  defp add(answers, advice_request_id) when is_list(answers) do
    answers
    |> Enum.map(&(Map.put(&1, :advice_request_id, advice_request_id)))
  end

  defp number?(number) do
    case Integer.parse(number) do
      {num, ""} -> num
      _ -> :not_a_number
    end
  end

  def find(advisories) when is_list(advisories) do
    ids = advisories |> Enum.map(fn(x) -> x.id end)

    Repo.all(from a in Answer, where: a.advice_request_id in ^ids)
  end
  def find(advisory) do
    answers_from_advisory = from a in Answer, where: a.advice_request_id == ^advisory.id

    Repo.all(answers_from_advisory)
  end

  def delete_all(advisories) do
    ids = Advice.ids(advisories)
    Repo.delete_all(from a in Answer, where: a.advice_request_id in ^ids)
  end
end
