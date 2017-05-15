defmodule Advisor.Core.Creator do
  alias Advisor.Core.Questionnaire
  alias Advisor.Repo

  def create(proposal) do
    Repo.insert(%Questionnaire{question_ids: proposal.questions,
                               requester_id: proposal.requester})
  end
end
