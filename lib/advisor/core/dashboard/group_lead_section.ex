defmodule Advisor.Core.Dashboard.GroupLeadSection do
  alias Advisor.Core.{People, Questionnaire, Advice}

  defstruct groups: []

  defmodule Group do
    defstruct [:questionnaire_id, :requester, :advisors]
  end

  def group_lead_section(group_lead) do
    groups = Questionnaire.for_group_lead(group_lead) |> expand()
    %__MODULE__{groups: groups}
  end

  # TODO: Is there a pattern around this? Behave the same for one or a list?
  defp expand(questionnaires) when is_list(questionnaires) do
    Enum.map(questionnaires, &expand/1)
  end
  defp expand(%{id: id} = questionnaire) do
    advisors = Advice.find_all(id) # this looks oddly named
               |> Enum.map(&People.advisor/1)

               # Why isn't this a pipeline?
    %Group{questionnaire_id: id, requester: People.requester(questionnaire), advisors: advisors}
  end
end
