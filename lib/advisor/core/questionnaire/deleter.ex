defmodule Advisor.Core.Questionnaire.Deleter do
  alias Advisor.Core.{Advice, Answers, Questionnaire}

  # TODO Turn this into some kind of cascading delete or so?
  def delete(id) do
    advice = Advice.find_all(id)
    Answers.delete_all(advice)
    Advice.delete_all(advice)
    Questionnaire.delete(id)
  end
end
