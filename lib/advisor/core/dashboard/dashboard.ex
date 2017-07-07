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
  defp expand(%{id: id} = questionnaire) do
    advisors = questionnaire
               |> Advice.all_for()
               |> Enum.map(&People.advisor/1)

    %{questionnaire_id: id, requester: People.requester(questionnaire), advisors: advisors}
  end

  def required_advice_section(%{id: advisor}) do
    advisor
    |> Questionnaire.with_advisor()
    |> Enum.map(fn(questionnaire) ->
      requester = People.requester(questionnaire)
      advice = Advice.from_advisor(advisor, for: requester)
      number_of_questions = length(questionnaire.question_ids)
      %{requester:  requester, advice: advice, completed: Advice.completed?(advice, number_of_questions)}
    end)
    |> Enum.reject(fn(%{completed: completed}) -> completed end)
  end

  def advice_for_me_section(%{id: person}) do
    case Questionnaire.with_requester(person) do
      nil -> :nothing
      questionnaire ->  Advice.all_for(questionnaire) |> Enum.map(&(people_and_completeness(&1, questionnaire)))
    end
  end

  def people_and_completeness(advice, %{question_ids: questions}) do
   nr_of_questions =  length(questions)
    %{advisor: People.advisor(advice),
      completed: Advice.completed?(advice, nr_of_questions)}
  end
end
