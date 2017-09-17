defmodule Advisor.Core.Questionnaire.Deleter do
  alias Advisor.Core.{Advice, Answers, Questionnaire}

  def delete(id) do
    Questionnaire.delete(id)
  end
end
