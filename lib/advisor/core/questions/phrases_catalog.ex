defmodule Advisor.Core.Questions.PhrasesCatalog do

  @path "lib/advisor/core/questions/questions.yml"

  # Maybe add a struct called `phrase`?

  # This feel brutally complicated... and do I really need them all?
  def all() do
    File.cwd!
    |> Path.join(@path)
    |> all()
  end
  def all(path) do
    path
    |> YamlElixir.read_from_file()
    |> extract()
  end
  def from_data(yaml) do
    yaml
    |> YamlElixir.read_from_string()
    |> extract()
  end

  # Gawd this is intricate and complicated...
  defp extract(yaml) do
    yaml
    |> Enum.reduce(%{counter: 1, data: %{}}, fn({kind, phrases}, %{counter: counter, data: data}) ->
      # Extract this function to its own module
      kind = String.to_atom(kind)
      questions = convert(phrases, kind, counter)
      %{counter: counter + length(questions), data: Map.put(data, kind, questions)}
    end)
    |> Map.fetch!(:data) # Why do I just keep a few little chunks?!
  end

  def find(yaml, ids) do
    yaml |> flatten() |> Enum.filter(fn(question) -> question.id in ids end)
  end
  def find(ids), do: all() |> find(ids)

  defp flatten(question_map), do: question_map |> Map.values |> List.flatten

  def phrases(questions), do: Enum.map(questions, fn(question) -> question.phrase end)

  # handcrafted reduce?
  defp convert([], _, _), do: []
  defp convert([value | others], kind, counter) do
    [%{phrase: value, kind: PhraseKind.to_i(kind), id: counter} | convert(others, kind, counter + 1)]
  end
end
