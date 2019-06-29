defmodule Advisor.Questionnaire.Creator do
  alias Advisor.Questionnaire

  def create(draft) do
    %{id: id} = Questionnaire.create(draft)
    Questionnaire.find(id)
  end
end
