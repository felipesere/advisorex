defmodule Advisor.Core.Questionnaire.Creator do
  alias Advisor.Core.{People, Questionnaire, Advice}
  alias Advisor.Core.Questionnaire.Created
  alias Advisor.Core.Questions
  alias Advisor.Repo

  def create(%{questions: questions,
               requester: requester,
               advisors: advisors,
               group_lead: group_lead}) do


    questions = Questions.store(questions)
    {:ok, questionnaire} = Repo.insert(%Questionnaire{question_ids: questions,
      requester_id: requester, group_lead: group_lead})

    advice_requests = Enum.map(advisors, fn(advisor) ->
      %{questionnaire_id: questionnaire.id,
        requester_id: requester,
        advisor_id: advisor}
   end)

    advisories = Advice
                 |> Repo.insert_all(advice_requests, returning: true)
                 |> elem(1)
                 |> Enum.map(&expanded_advisor/1)

    {:ok, %Created{questionnaire:  questionnaire.id, advisories: advisories}}
  end

  defp expanded_advisor(%{id: id} = advice) do
    %{advisor: People.advisor(advice), id: id}
  end
end
