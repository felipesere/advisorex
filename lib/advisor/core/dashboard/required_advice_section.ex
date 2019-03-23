defmodule Advisor.Core.Dashboard.RequiredAdviceSection do
  alias Advisor.Core.{Questionnaire, Advice}

  def required_advice_section(%{id: advisor}) do
    advisor
    |> Advice.from_advisor()
    |> Enum.map(fn advice ->
      questionnaire = Questionnaire.find(advice)
      requester = questionnaire.requester
      # temp...
      completed = Advice.completed?(advice, questionnaire.question_ids)
      %{requester: requester, advice: advice, completed: completed}
    end)
    |> Enum.reject(fn %{completed: completed} -> completed end)
  end
end
