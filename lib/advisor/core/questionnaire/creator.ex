defmodule Advisor.Core.Questionnaire.Creator do
  alias Advisor.Core.{People, Questions, Questionnaire, Advice}
  alias Ecto.Multi
  alias Advisor.Repo

  def create(%{questions: phrases} = proposal) do
    proposal =
      proposal
      |> Map.update!(:mentee, &People.find_by(id: &1))

    # TODO: this needs revisiting!
    m =
      Multi.new()
      |> Multi.run(:question_ids, fn _repo, _changes -> Questions.store(phrases) end)
      |> Multi.run(:questionnaire, fn _repo, params -> Questionnaire.create(params, proposal) end)
      |> Multi.run(:advisories, fn _repo, params -> Advice.create(params, proposal) end)
      |> Multi.run(:q, fn _repo, %{questionnaire: q} -> {:ok, Questionnaire.find(q.id)} end)
      |> Repo.transaction()

    case m do
      {:ok, data} -> data.q
      error -> error
    end
  end
end
