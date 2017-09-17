defmodule Advisor.Core.Dashboard do
  alias Advisor.Core.{People, Questionnaire, Advice}
  alias Advisor.Core.Dashboard.GroupLeadSection
  alias Advisor.Core.Person

  defstruct [:group_lead_section, :required_advice_section, :personal_advice_section]

  def for_user(viewer) do
    %__MODULE__{
      group_lead_section: GroupLeadSection.group_lead_section(viewer)
    }
  end

  def group_lead_section(viewer), do: GroupLeadSection.group_lead_section(viewer)

  # TODO: this anonymous map function looks massive!
  def required_advice_section(%{id: advisor}) do
    advisor
    |> Questionnaire.with_advisor()
    |> Enum.map(fn(%{question_ids: ids} = questionnaire) ->
      requester = People.requester(questionnaire)
      advice    = Advice.from_advisor(advisor, for: requester)
      completed = Advice.completed?(advice, length(ids))
      %{requester:  requester, advice: advice, completed:  completed}
    end)
    |> Enum.reject(fn(%{completed: completed}) -> completed end)
  end

  # TODO: Can I turn this into its own little struct?
  def advice_for_me_section(%{id: person}) do
    case Questionnaire.with_requester(person) do
      nil -> :nothing
      questionnaire -> section_for(questionnaire)
    end
  end

  # TODO: Can I turn this into its own little struct?
  defp section_for(questionnaire) do
    questionnaire
    |> Advice.find_all() # Meeeeeeeeeh
    |> Enum.map(&(people_and_completeness(&1, questionnaire)))
  end

  def people_and_completeness(advice, %{question_ids: questions}) do
   nr_of_questions = length(questions)
    %{advisor:   People.advisor(advice),
      completed: Advice.completed?(advice, nr_of_questions)}
  end
end
