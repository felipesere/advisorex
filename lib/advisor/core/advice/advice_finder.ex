defmodule Advisor.Core.AdviceFinder do
  alias Advisor.Core.Advice
  alias Advisor.Repo
  import Ecto.Query

  def all_for(id) do
    query = from advice in Advice, where: advice.questionnaire_id == ^id
    Repo.all(query)
  end

  def find(id) do
    Repo.get(Advice, id)
  end
  def find(advice_id, [from_advisor: %{id: advisor_id}]) do
    Repo.one(from a in Advice, where: a.id == ^advice_id and a.advisor_id == ^advisor_id)
  end
end
