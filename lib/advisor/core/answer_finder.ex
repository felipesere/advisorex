defmodule Advisor.Core.AnswerFinder do
  alias Advisor.Core.Answer
  alias Advisor.Repo
  import Ecto.Query

  def gather(advisories) do
    Enum.map(advisories, &(find_all(&1)))
  end

  defp find_all(advisory) do
    answers_from_advisory = from a in Answer,
      where: a.advice_request_id == ^advisory.id

    answers = Repo.all(answers_from_advisory)

    %{advisory: advisory, answers: answers}
  end
end
