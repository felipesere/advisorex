defmodule Advisor.Core.Notes do
  alias Advisor.Repo
  alias Advisor.Core.Note

  def store(params) do
    Repo.insert_all(Note, note_in(params), returning: true)
  end

  def note_in(params) do
    params
    |> Enum.reject(fn({key, _}) -> key != "note" end)
    |> List.first
    |> to_note
  end

  def to_note({_, value}) when value != "" do
    [%{:note => value}]
  end
  def to_note({_, value}) do
    []
  end
end
