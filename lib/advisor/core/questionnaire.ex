defmodule Advisor.Core.Questionnaire do
  alias Advisor.Core.{People, Questions}

  def form_data() do
    everybody = People.everybody()
    group_leads = Enum.filter(everybody, &who_is_a_group_lead/1)
    questions = Questions.all()

    {everybody, group_leads, questions}
  end

  defp who_is_a_group_lead(person), do: person.is_group_lead
end
