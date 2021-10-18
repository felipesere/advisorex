defmodule Advisor.Question.PhrasesCatalog do
  require Logger

  defmodule Phrase do
    defstruct [:phrase, :kind, :id]
  end

  def child_spec(_arg) do
    %{
       id: Advisor.Question.PhrasesCatalog,
       start: {Advisor.Question.PhrasesCatalog, :start_link, []}
    }
  end

  def start_link() do
    questions = load()

    Agent.start_link(fn() -> questions end, name: __MODULE__)
  end

  def load() do
    path()
    |> log()
    |> read()
    |> extract()
  end

  def all() do
    Agent.get(__MODULE__, fn(questions) -> questions end)
  end

  def find(ids) do
    all()
    |> flatten()
    |> Enum.filter(fn %Phrase{id: id} -> id in ids end)
  end

  defp read(file) do
    {:ok, content} = YamlElixir.read_from_file(file)

    content
  end

  defp path() do
    File.cwd!()
    |> Path.join(configured_path())
    |> String.to_charlist()
  end

  defp configured_path() do
    :advisor
    |> Application.get_env(Advisor.Question.PhrasesCatalog)
    |> Keyword.get(:path)
  end

  defp log(path) do
    Logger.info "Loading questions from: #{path}"

    path
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
