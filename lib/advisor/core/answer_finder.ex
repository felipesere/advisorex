defmodule Advisor.Core.AnswerFinder do
  alias Advisor.Core.Answer
  alias Advisor.Repo
  import Ecto.Query

  def gather(advisories) do
    Enum.map(advisories, &(find_all(&1)))
  end

  defp find_all(advisory) do
    query = from answer in Answer, where: answer.advice_request_id == ^advisory.id
    %{advisory: advisory, answers: Repo.all(query)}
  end
end
