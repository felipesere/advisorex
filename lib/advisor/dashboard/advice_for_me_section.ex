defmodule Advisor.Dashboard.AdviceForMeSection do
  alias Advisor.{Questionnaire, Advice}

  def advice_for_me_section(%{id: person}) do
    case Questionnaire.with_mentee(person) do
      nil -> :nothing
      questionnaire -> section_for(questionnaire)
    end
  end

  defp section_for(%{advice: advices, questions: questions}) do
    Enum.map(advices, fn advice ->
      %{
        advisor: advice.advisor,
        completed: Advice.completed?(advice, questions)
      }
    end)
  end
end
