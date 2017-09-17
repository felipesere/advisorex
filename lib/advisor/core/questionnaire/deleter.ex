defmodule Advisor.Core.Questionnaire.Deleter do
  alias Advisor.Core.{Advice, Answers, Questionnaire}

  # TODO: the last cascade would be to "only" delete the Questionnaire
  def delete(id) do
    Advice.remove(id)
    Questionnaire.delete(id)
  end
end
