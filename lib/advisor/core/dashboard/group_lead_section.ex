defmodule Advisor.Core.Dashboard.GroupLeadSection do
  alias Advisor.Core.{Person, People, Questionnaire}

  defstruct groups: []

  defmodule Group do
    defstruct [:questionnaire_id, :requester, :advisors]
  end

  def group_lead_section(%Person{is_group_lead: false}) do
    %__MODULE__{groups: []}
  end
  def group_lead_section(%Person{is_group_lead: true, id: group_lead}) do
    group_lead
    |> Questionnaire.all_for_group_lead()
    |> Enum.map(&to_group/1)
    |> to_section()
  end

  defp to_section(groups) do
    %__MODULE__{groups: groups}
  end

  defp to_group(%{id: id} = questionnaire) do
    %Group{
      questionnaire_id: id,
      requester: People.requester(questionnaire),
      advisors: all_advisors(questionnaire)
    }
  end

  defp all_advisors(%{advice: advice}), do: Enum.map(advice, &People.advisor/1)
end
