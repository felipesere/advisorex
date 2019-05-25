defmodule Advisor.Core.Questionnaire.Creator do
  alias Advisor.Core.Questionnaire

  def create(proposal) do
    %{id: id} = Questionnaire.create(proposal)
    Questionnaire.find(id)
  end
end
