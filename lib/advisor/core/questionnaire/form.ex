# TODO: Odd name for a module, too generic, doesn't say much
defmodule Advisor.Core.Questionnaire.Form do
  alias Advisor.Core.People
  alias Advisor.Core.Questions.PhrasesCatalog

  # TODO: Try to eliminate the forced ordering
  def data_for(person) do
    everybody = People.everybody_but(person)
    group_leads = Enum.filter(everybody, &who_is_a_group_lead/1)
    questions = PhrasesCatalog.all()

    {everybody, group_leads, questions}
  end

  defp who_is_a_group_lead(person), do: person.is_group_lead
end
