defmodule Advisor.Core.NotesTest do
  use Advisor.DataCase
  alias Advisor.Core.Notes

  test "note_in? true" do
    params = %{"id" => "id",
               "note" => "some note"}

    assert Notes.note_in?(params)
  end

  test "note_in? false" do
    params = %{"id" => "id",
               "note" => ""}

    refute Notes.note_in?(params)
  end
end
