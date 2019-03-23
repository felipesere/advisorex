defmodule Advisor.Core.Dashboard do
  alias Advisor.Core.Dashboard.{GroupLeadSection, RequiredAdviceSection, AdviceForMeSection}
  alias Advisor.Core.Questionnaire

  defstruct [
    :group_lead_section,
    :required_advice_section,
    :personal_advice_section,
    :existing_questionnaire
  ]

  def for_user(viewer) do
    %__MODULE__{
      group_lead_section: GroupLeadSection.group_lead_section(viewer),
      required_advice_section: RequiredAdviceSection.required_advice_section(viewer),
      personal_advice_section: AdviceForMeSection.advice_for_me_section(viewer),
      existing_questionnaire: Questionnaire.with_requester(viewer.id)
    }
  end
end
