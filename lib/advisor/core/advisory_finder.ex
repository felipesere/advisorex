defmodule Advisor.Core.AdvisoryFinder do
  alias Advisor.Core.AdviceRequest
  alias Advisor.Repo
  import Ecto.Query

  def gather_for_questionnaire(id) do
    query = from ar in AdviceRequest, where: ar.questionnaire_id == ^id
    Repo.all(query)
  end

  def find(id) do
    Repo.get(AdviceRequest, id)
  end
  def find(id, [for_user: %{id: user_id}]) do
    Repo.one(from ar in AdviceRequest, where: ar.id == ^id and ar.advisor_id == ^user_id)
  end
end
