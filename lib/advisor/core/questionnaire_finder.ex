defmodule Advisor.Core.QuestionnaireFinder do
  alias Advisor.Core.Questionnaire
  alias Advisor.Repo

  def find(id) do
    Repo.get(Questionnaire, id)
  end
end
