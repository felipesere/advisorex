defmodule Advisor.Core.Questions do
  alias Advisor.Core.Questions.YamlQuestions
  alias Advisor.Core.Question

  defdelegate all(), to: YamlQuestions
  defdelegate find(ids), to: YamlQuestions

  def phrases(questions), do: Enum.map(questions, fn(question) -> question.phrase end)

  def store(phrases), do: Question.store_all(phrases)

  def load(uuids), do: Question.load(uuids)
end

