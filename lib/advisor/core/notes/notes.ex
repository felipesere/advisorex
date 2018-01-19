defmodule Advisor.Core.Notes do
  alias Advisor.Repo
  alias Advisor.Core.Note

  def store(%{"note" => text}, %{id: id}) do
    Repo.insert(%Note{note: text, advice_request_id: id}, returning: true)
  end

  def note_in?(%{"note" => value}) do
    value != ""
  end
end
