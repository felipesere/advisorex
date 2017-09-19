defmodule Advisor.Core.Questions do
  alias Advisor.Core.Question

  # TODO:  Is this already a code smell? Or a comfy pattern?
  defdelegate store(phrases), to: Question
  defdelegate load(uuids), to: Question

  def phrases(questions), do: Enum.map(questions, fn(question) -> question.phrase end)
end
