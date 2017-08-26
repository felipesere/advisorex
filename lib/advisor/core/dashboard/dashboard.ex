defmodule Advisor.Core.Dashboard do
  alias Advisor.Core.{People, Questionnaire, Advice}

  # Can I turn this into a little struct?
  def group_lead_section(%{id: group_lead}) do
    group_lead
    |> Questionnaire.for_group_lead()
    |> expand()
  end

  # Is there a pattern around this? Behave the same for one or a list?
  defp expand(questionnaires) when is_list(questionnaires) do
    Enum.map(questionnaires, &expand/1)
  end
  defp expand(%{id: id} = questionnaire) do
    advisors = questionnaire
               |> Advice.all_for() # this looks oddly named
               |> Enum.map(&People.advisor/1)

               # Why isn't this a pipeline?
    %{questionnaire_id: id, requester: People.requester(questionnaire), advisors: advisors}
  end

  # this anonymous map function looks massive!
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

  # Can I turn this into its own little struct?
  def advice_for_me_section(%{id: person}) do
    case Questionnaire.with_requester(person) do
      nil -> :nothing
      questionnaire -> section_for(questionnaire)
    end
  end

  # Can I turn this into its own little struct?
  defp section_for(questionnaire) do
    questionnaire
    |> Advice.all_for() # Meeeeeeeeeh
    |> Enum.map(&(people_and_completeness(&1, questionnaire)))
  end

  def people_and_completeness(advice, %{question_ids: questions}) do
   nr_of_questions = length(questions)
    %{advisor:   People.advisor(advice),
      completed: Advice.completed?(advice, nr_of_questions)}
  end
end
