defmodule Advisor.Core.Questions do
  alias Advisor.Repo
  alias Advisor.Core.{Question, Questionnaire}
  import Ecto.Query

  def all() do
    Question
    |> Repo.all
    |> Enum.group_by(&(&1.kind))
    |> coerce()
  end

  def find(ids) do
    Repo.all(from q in Question, where: q.id in ^ids)
  end

  def of_questionnaire(id) do
    questions = from qs in Questionnaire,
      join: q in Question, on: q.id in qs.question_ids,
      where: qs.id == ^id,
      select: q.phrase

    Repo.all(questions)
  end

  defp coerce(elements) do
    elements
    |> Enum.map(fn({key, value}) -> {convert_key(key), value} end)
    |> Enum.into(%{})
  end

  defp convert_key(key) do
    case key do
      1 -> :technical
      2 -> :client
      3 -> :community
    end
  end
end
