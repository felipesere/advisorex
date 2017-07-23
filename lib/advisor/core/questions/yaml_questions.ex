defmodule Advisor.Core.Questions.YamlQuestions do
  alias Advisor.Core.Question

  @path "lib/advisor/core/questions/questions.yml"

  def all() do
    File.cwd!
    |> Path.join(@path)
    |> YamlElixir.read_all_from_file()
    |> List.first
    |> Enum.reduce(%{counter: 1, data: %{}}, fn({kind, phrases}, %{counter: counter, data: data}) ->
      kind = String.to_atom(kind)
      questions = convert(phrases, kind, counter)
      %{counter: counter + length(questions), data: Map.put(data, kind, questions)}
    end)
    |> Map.fetch!(:data)
  end

  def find(ids) do
    all() |> flatten() |> Enum.filter(fn(question) -> question.id in ids end)
  end

  defp flatten(question_map), do: question_map |> Map.values |> List.flatten

  def phrases(questions), do: Enum.map(questions, fn(question) -> question.phrase end)

  defp convert([], _, _), do: []
  defp convert([value | others], kind, counter) do
    [%Question{phrase: value, kind: id_of(kind), id: counter} | convert(others, kind, counter + 1)]
  end

  defp id_of(:technical), do: 1
  defp id_of(:client), do: 2
  defp id_of(:community), do: 3
end
