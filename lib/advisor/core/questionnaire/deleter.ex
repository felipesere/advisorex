defmodule Advisor.Core.Questionnaire.Deleter do
  alias Advisor.Core.{Advice, Answers, Questionnaire}

  def delete(id) do
    advice = Advice.all_for(id)
    Answers.delete_all(advice)
    Advice.delete_all(advice)
    Questionnaire.delete(id)
  end
end
