defmodule Advisor.Core.Dashboard.GroupLeadSection do
  alias Advisor.Core.{People, Questionnaire, Advice}

  defstruct groups: []

  defmodule Group do
    defstruct [:questionnaire_id, :requester, :advisors]
  end

  def group_lead_section(group_lead) do
    group_lead
    |> Questionnaire.all_for_group_lead()
    |> Enum.map(&to_group/1)
    |> to_section()
  end

  def empty(), do: %__MODULE__{groups: []}

  defp to_section(groups) do
    %__MODULE__{groups: groups}
  end

  defp to_group(%{id: id} = questionnaire) do
    %Group{
      questionnaire_id: id,
      requester: People.requester(questionnaire),
      advisors: all_advisors(id)
    }
  end

  defp all_advisors(questionnaire_id) do
    questionnaire_id
    |> Advice.find_all()
    |> Enum.map(&People.advisor/1)
  end
end
