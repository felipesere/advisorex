defmodule Advisor.Core.Questionnaire.Creator do
  alias Advisor.Core.{People, Questions, Questionnaire, Advice}
  alias Ecto.Multi
  alias Advisor.Repo

  def create(%{questions: phrases} = proposal) do

    proposal = proposal
               |> Map.update!(:requester, & People.find_by(id: &1))

    m = Multi.new()
    |> Multi.run(:question_ids,  fn(_) -> Questions.store(phrases) end)
    |> Multi.run(:questionnaire, fn(params) -> Questionnaire.create(params, proposal) end)
    |> Multi.run(:advisories,    fn(params) -> Advice.create(params, proposal)  end)
    |> Multi.run(:q,             fn(%{questionnaire: q}) -> {:ok, Questionnaire.find(q.id)} end)
    |> Repo.transaction()

    case m do
      {:ok, data} -> data.q
      error -> error
    end
  end
end
