defmodule Advisor.Core.Notes do
  alias Advisor.Repo
  alias Advisor.Core.Note

  def store(%{"note" => text}) do
    Repo.insert(%Note{note: text}, returning: true)
  end

  def note_in?(%{"note" => value}) do
    value != ""
  end
end
