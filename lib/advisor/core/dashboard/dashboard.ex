defmodule Advisor.Core.Dashboard do
  alias Advisor.Core.{People, Questionnaire, Advice}

  def group_lead_section(%{id: group_lead}) do
    group_lead
    |> Questionnaire.for_group_lead()
    |> expand()
  end

  defp expand(questionnaires) when is_list(questionnaires) do
    Enum.map(questionnaires, &expand/1)
  end
  defp expand(questionnaire) do
    advisors = questionnaire
               |> Advice.all_for()
               |> Enum.map(&People.advisor/1)

    %{requester: People.requester(questionnaire), advisors: advisors}
  end
end
