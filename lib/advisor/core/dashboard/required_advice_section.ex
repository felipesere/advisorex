defmodule Advisor.Core.Dashboard.RequiredAdviceSection do
  alias Advisor.Core.{Questionnaire, Advice}

  def required_advice_section(%{id: advisor}) do
    advisor
    |> Advice.from_advisor()
    |> Enum.map(fn advice ->
      questionnaire = Questionnaire.find(advice)
      mentee = questionnaire.mentee
      completed = Advice.completed?(advice, questionnaire.questions)
      %{mentee: mentee, advice: advice, completed: completed}
    end)
    |> Enum.reject(fn %{completed: completed} -> completed end)
  end
end
