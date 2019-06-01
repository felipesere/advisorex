defmodule Advisor.Question.PhrasesCatalog do
  defmodule Phrase do
    defstruct [:phrase, :kind, :id]
  end

  @path "lib/advisor/questions/questions.yml"

  def find(ids) do
    all()
    |> flatten()
    |> Enum.filter(fn %Phrase{id: id} -> id in ids end)
  end

  def all() do
    path()
    |> read()
    |> extract()
  end

  defp path() do
    File.cwd!()
    |> Path.join(@path)
    |> String.to_charlist()
  end

  defp read(file) do
    {:ok, content} = YamlElixir.read_from_file(file)

    content
  end

  defp extract(yaml) do
    yaml
    |> zip()
    |> Enum.with_index()
    |> Enum.map(&to_phrase/1)
    |> Enum.group_by(&kind/1, & &1)
  end

  defp kind(%Phrase{kind: kind}), do: kind

  defp zip(map) do
    map
    |> Enum.flat_map(fn {key, elements} ->
      Enum.map(elements, fn v -> {key, v} end)
    end)
  end

  defp to_phrase({{kind, phrase}, id}) do
    %Phrase{kind: String.to_atom(kind), phrase: phrase, id: id}
  end

  defp flatten(phrases) do
    phrases
    |> Map.values()
    |> List.flatten()
  end
end
