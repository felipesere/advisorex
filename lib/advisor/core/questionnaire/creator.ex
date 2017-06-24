defmodule Advisor.Core.Questionnaire.Creator do
  alias Advisor.Core.{People, Questionnaire, Advice}
  alias Advisor.Core.Questionnaire.Created
  alias Advisor.Core.Advice.Advisory
  alias Advisor.Repo

  def create(%{questions: questions,
               requester: requester,
               advisors: advisors}) do
    {:ok, questionnaire} = Repo.insert(%Questionnaire{question_ids: questions,
                               requester_id: requester})

    advice_requests = Enum.map(advisors, fn(advisor) ->
      %{questionnaire_id: questionnaire.id,
        requester_id: requester,
        advisor_id: advisor}
    end)

    advisories = Advice
                 |> Repo.insert_all(advice_requests, returning: true)
                 |> elem(1)
                 |> Enum.map(&to_advisory/1)

    {:ok, %Created{questionnaire:  questionnaire.id, advisories: advisories}}
  end

  defp to_advisory(%{advisor_id: advisor_id, id: id}) do
    %Advisory{advisor: People.find_by_id(advisor_id), advice_id: id}
  end
end
