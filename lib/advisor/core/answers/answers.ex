defmodule Advisor.Core.Answers do
  alias Advisor.Repo
  alias Advisor.Core.Answer
  alias Advisor.Core.Advice
  import Ecto.Query

  @ignored_keys ["id", "_csrf_token", "note"]

  def store(params) do
    Repo.insert_all(Answer, all_answers_in(params), returning: true)
  end

  def all_answers_in(%{"id" => advice_request_id} = params) do
    params
    |> Enum.reject(fn({key, _}) -> key in @ignored_keys end)
    |> Enum.map(&to_answer/1)
    |> add(advice_request_id)
  end

  # TODO This feels to intricite... map into Map put?
  defp to_answer({question_id, answer}) do
    %{question_id: question_id, answer: answer}
  end

  # TODO This feels to intricite... map into Map put?
  defp add(answers, advice_request_id) do
    answers
    |> Enum.map(&(Map.put(&1, :advice_request_id, advice_request_id)))
  end

  def find(questionnaire) do
    ids = Advice.ids(questionnaire.advice)

    Repo.all(from a in Answer, where: a.advice_request_id in ^ids)
  end
end
