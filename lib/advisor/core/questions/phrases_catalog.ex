defmodule Advisor.Core.Questions.PhrasesCatalog do
  alias Advisor.Core.Questions.Phrase

  @path "lib/advisor/core/questions/questions.yml"

  # TODO Maybe add a struct called `phrase`?

  # TODO This feel brutally complicated...
  # ...and do I really need them all? Maybe I can push this into a spearet module too
  def all() do
    File.cwd!
    |> Path.join(@path)
    |> YamlElixir.read_from_file()
    |> extract()
  end

  # TODO: Gawd this is intricate and complicated...
  defp extract(yaml) do
    yaml
    |> Enum.reduce(%{counter: 1, data: %{}}, fn({kind, phrases}, %{counter: counter, data: data}) ->
      kind = String.to_atom(kind)
      questions = convert(phrases, kind, counter)
      %{counter: counter + length(questions), data: Map.put(data, kind, questions)}
    end)
    |> Map.fetch!(:data) # Why do I just keep a few little chunks?!
  end

  def find(yaml, ids) do
    yaml |> flatten() |> Enum.filter(fn(question) -> question.id in ids end)
  end
  def find(ids) do
    all() |> find(ids)
  end

  defp flatten(question_map), do: question_map |> Map.values |> List.flatten

  def phrases(questions), do: Enum.map(questions, fn(question) -> question.phrase end)

  defp convert(phrases, kind, counter) do
    phrases
    |> Enum.with_index(counter)
    |> Enum.map(fn({phrase, id}) ->
      %Phrase{phrase: phrase, kind: kind, id: id}
    end)
  end
end
