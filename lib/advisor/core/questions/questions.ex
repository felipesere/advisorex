defmodule Advisor.Core.Questions do
  alias Advisor.Core.Questions.PhrasesCatalog
  alias Advisor.Core.Question

  # Is this already a code smell? Or a comfy pattern?
  defdelegate all(), to: PhrasesCatalog
  defdelegate find(ids), to: PhrasesCatalog

  defdelegate store(phrases), to: Question
  defdelegate load(phrases), to: Question

  def phrases(questions), do: Enum.map(questions, fn(question) -> question.phrase end)
end
