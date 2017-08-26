defmodule Advisor.Core.Questions do
  alias Advisor.Core.Questions.YamlQuestions
  alias Advisor.Core.Question

  # Is this already a code smell? Or a comfy pattern?
  defdelegate all(), to: YamlQuestions
  defdelegate find(ids), to: YamlQuestions

  defdelegate store(phrases), to: Question
  defdelegate load(phrases), to: Question

  def phrases(questions), do: Enum.map(questions, fn(question) -> question.phrase end)
end
