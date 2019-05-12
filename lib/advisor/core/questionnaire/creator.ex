defmodule Advisor.Core.Questionnaire.Creator do
  alias Advisor.Core.{People, Question, Questionnaire, Advice}
  alias Ecto.Multi
  alias Advisor.Repo

  def create(%{questions: phrases, mentee: mentee} = proposal) do
    multi =
      Multi.new()
      |> Multi.run(:mentee, fn _, _ -> {:ok, People.find_by(id: mentee)} end)
      |> Multi.run(:question_ids, fn _, _ -> {:ok, Question.store(phrases)} end)
      |> Multi.run(:questionnaire, fn _, params -> Questionnaire.create(params, proposal) end)
      |> Multi.run(:advisories, fn _, params -> Advice.create(params, proposal) end)
      |> Multi.run(:result, fn _, %{questionnaire: q} -> {:ok, Questionnaire.find(q.id)} end)

    case Repo.transaction(multi) do
      {:ok, %{result: result}} -> result
      error -> error
    end
  end
end
