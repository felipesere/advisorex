defmodule Advisor.Core.Creator do
  alias Advisor.Core.{People, Questionnaire, AdviceRequest}
  alias Advisor.Core.Questionnaire.Created
  alias Advisor.Core.AdviceRequest.Advisory
  alias Advisor.Repo

  def create(proposal) do
    {:ok, questionnaire} = Repo.insert(%Questionnaire{question_ids: proposal.questions,
                               requester_id: proposal.requester})

    advice_requests = Enum.map(proposal.advisors, fn(advisor) ->
      %{questionnaire_id: questionnaire.id,
        requester_id: proposal.requester,
        advisor_id: advisor}
    end)

    advisories = AdviceRequest
                 |> Repo.insert_all(advice_requests, returning: true)
                 |> elem(1)
                 |> Enum.map(&%Advisory{advisor: People.find_by_id(&1.advisor_id), advice_id: &1.id})

    {:ok, %Created{questionnaire:  questionnaire.id, advisories: advisories}}
  end
end
