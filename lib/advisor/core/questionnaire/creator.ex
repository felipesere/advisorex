defmodule Advisor.Core.Questionnaire.Creator do
  alias Advisor.Core.{People, Questions, Questionnaire, Advice}

  def create(%{questions: phrases,
               requester: requester,
               advisors: advisors,
               group_lead: group_lead} = proposal) do
    message = Map.get(proposal, :message)

    question_ids = Questions.store(phrases)
    questionnaire = Questionnaire.create(question_ids, requester, group_lead, message)
    advisories = Advice.create(questionnaire, requester, advisors) |> expanded_advisor()

    %{questionnaire:  questionnaire, advisories: advisories}
  end

  defp expanded_advisor({_, advisories}) do
    Enum.map(advisories, fn(advice) ->
      %{advisor: People.advisor(advice), id: advice.id}
    end)
  end
end
