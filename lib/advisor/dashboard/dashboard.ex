defmodule Advisor.Dashboard do
  alias Advisor.Dashboard.{MentorSection, RequiredAdviceSection, AdviceForMeSection}
  alias Advisor.Questionnaire

  defstruct [
    :mentor_section,
    :required_advice_section,
    :personal_advice_section,
    :existing_questionnaire
  ]

  def for_user(viewer) do
    %__MODULE__{
      mentor_section: MentorSection.mentor_section(viewer),
      required_advice_section: RequiredAdviceSection.required_advice_section(viewer),
      personal_advice_section: AdviceForMeSection.advice_for_me_section(viewer),
      existing_questionnaire: Questionnaire.with_mentee(viewer.id)
    }
  end
end
