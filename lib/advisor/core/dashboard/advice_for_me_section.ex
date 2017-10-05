defmodule Advisor.Core.Dashboard.AdviceForMeSection do
  alias Advisor.Core.{People, Questionnaire, Advice}

  def advice_for_me_section(%{id: person}) do
    case Questionnaire.with_requester(person) do
      nil -> :nothing
      questionnaire -> section_for(questionnaire)
    end
  end

  defp section_for(questionnaire) do
    questionnaire.advice
    |> Enum.map(&(people_and_completeness(&1, questionnaire)))
  end

  def people_and_completeness(advice, %{question_ids: questions}) do
    %{
      advisor:   People.advisor(advice),
      completed: Advice.completed?(advice, questions)
    }
  end
end
