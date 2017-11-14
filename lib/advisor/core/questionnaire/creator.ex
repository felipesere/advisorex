defmodule Advisor.Core.Questionnaire.Creator do
  alias Advisor.Core.{People, Questions, Questionnaire, Advice}
  alias Advisor.Core.Questionnaire.Created
  alias Advisor.Repo

  def create(%{questions: phrases,
               requester: requester,
               advisors: advisors,
               group_lead: group_lead} = proposal) do

    message = Map.get(proposal, :message)

    question_ids = Questions.store(phrases)
    {:ok, questionnaire} = Repo.insert(%Questionnaire{question_ids: question_ids,
                                                      requester_id: requester,
                                                      group_lead: group_lead,
                                                      message: message})

    # TODO: Why is't this a proper struct?
    advice_requests = Enum.map(advisors, fn(advisor) ->
      %{questionnaire_id: questionnaire.id,
        requester_id: requester,
        advisor_id: advisor}
   end)

    advisories = Advice
                 |> Repo.insert_all(advice_requests, returning: true)
                 |> elem(1) # TODO: There is something off here too
                 |> Enum.map(&expanded_advisor/1)

    {:ok, %Created{questionnaire:  questionnaire.id, advisories: advisories}}
  end

  defp expanded_advisor(%{id: id} = advice) do
    %{advisor: People.advisor(advice), id: id}
  end
end
