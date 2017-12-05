defmodule Advisor.Core.Questions do
  alias Advisor.Core.Question

  defdelegate load(uuids), to: Question

  def store(phrases) do
    {:ok, Question.store(phrases)}
  end
  def phrases(questions), do: Enum.map(questions, fn(question) -> question.phrase end)
end
