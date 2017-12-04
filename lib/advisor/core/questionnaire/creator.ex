defmodule Advisor.Core.Questionnaire.Creator do
  alias Advisor.Core.{People, Questions, Questionnaire, Advice}
  alias Ecto.Multi
  alias Advisor.Repo

  def create(%{questions: phrases,
               requester: requester_id,
               advisors: advisors,
               group_lead: group_lead} = proposal) do
    message = Map.get(proposal, :message)

    requester = People.find_by(id: requester_id)

    m = Multi.new()
    |> Multi.run(:question_ids,  fn(_) -> Questions.store(phrases) end)
    |> Multi.run(:questionnaire, fn(params) -> Questionnaire.create(params, requester, group_lead, message) end)
    |> Multi.run(:advisories,    fn(params) -> Advice.create(params, requester_id, advisors)  end)
    |> Multi.run(:q,             fn(%{questionnaire: q}) -> {:ok, Questionnaire.find(q.id)} end)
    |> Repo.transaction()

    case m do
      {:ok, data} -> %{questionnaire: data.q, advisories: data.advisories |> expand()}
      error -> error
    end
  end

  defp expand(advisories) do
    Enum.map(advisories, fn(advice) ->
      %{advisor: People.advisor(advice), id: advice.id}
    end)
  end
end
