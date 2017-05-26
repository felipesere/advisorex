defmodule Advisor.Core.QuestionnaireFinder do
  alias Advisor.Core.Questionnaire
  alias Advisor.Repo
  import Ecto.Query

  def find(id) do
    Repo.get(Questionnaire, id)
  end
end
