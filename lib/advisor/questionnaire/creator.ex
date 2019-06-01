defmodule Advisor.Questionnaire.Creator do
  alias Advisor.Questionnaire

  def create(proposal) do
    %{id: id} = Questionnaire.create(proposal)
    Questionnaire.find(id)
  end
end
