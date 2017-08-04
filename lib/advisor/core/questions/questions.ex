defmodule Advisor.Core.Questions do
  alias Advisor.Core.Questions.Server
  alias Advisor.Core.Questions.YamlQuestions

  defdelegate all(), to: YamlQuestions
  defdelegate find(ids), to: YamlQuestions

  def phrases(questions), do: Enum.map(questions, fn(question) -> question.phrase end)
end

