defmodule Advisor.Core.Dashboard do
  alias Advisor.Core.Dashboard.{GroupLeadSection, RequiredAdviceSection, AdviceForMeSection}

  defstruct [:group_lead_section, :required_advice_section, :personal_advice_section]

  def for_user(viewer) do
    %__MODULE__{
      group_lead_section: GroupLeadSection.group_lead_section(viewer),
      required_advice_section: RequiredAdviceSection.required_advice_section(viewer),
      personal_advice_section: AdviceForMeSection.advice_for_me_section(viewer)
    }
  end

  def group_lead_section(viewer), do: GroupLeadSection.group_lead_section(viewer)

  def required_advice_section(advisor), do: RequiredAdviceSection.required_advice_section(advisor)

  def advice_for_me_section(person), do: AdviceForMeSection.advice_for_me_section(person)
end
