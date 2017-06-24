defmodule Advisor.Core.AdviceFinder do
  alias Advisor.Core.Advice
  alias Advisor.Repo
  import Ecto.Query

  def gather_for_questionnaire(id) do
    query = from advice in Advice, where: advice.questionnaire_id == ^id
    Repo.all(query)
  end

  def find(id) do
    Repo.get(Advice, id)
  end
  def find(id, [for_user: %{id: user_id}]) do
    Repo.one(from a in Advice, where: a.id == ^id and a.advisor_id == ^user_id)
  end
end
