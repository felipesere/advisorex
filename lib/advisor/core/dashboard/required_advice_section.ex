defmodule Advisor.Core.Dashboard.RequiredAdviceSection do
  alias Advisor.Core.{People, Questionnaire, Advice}

  def required_advice_section(%{id: advisor}) do
    advisor
    |> Advice.from_advisor()
    |> Enum.map(fn(advice) ->
      questionnaire = Questionnaire.find(advice)
      requester = People.requester(questionnaire)
      completed = Advice.completed?(advice, questionnaire.question_ids) # temp...
      %{requester:  requester, advice: advice, completed:  completed}
    end)
    |> Enum.reject(fn(%{completed: completed}) -> completed end)
  end
end
