defmodule Advisor.Core.AdvisoryFinder do
  alias Advisor.Core.AdviceRequest
  alias Advisor.Repo
  import Ecto.Query

  def gather_for_questionnaire(id) do
    query = from ar in AdviceRequest, where: ar.questionnaire_id == ^id
    Repo.all(query)
  end
end
