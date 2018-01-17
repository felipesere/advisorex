defmodule Advisor.Core.NotesTest do
  use Advisor.DataCase
  alias Advisor.Core.Notes

  test "returns empty list when note param is empty string" do
    params = %{"uuid-1" => "answer_1",
               "uuid-2" => "answer_2",
               "_csrf_token" => "token",
               "id" => "id",
               "note" => ""}

    notes = Notes.note_in(params)

    assert notes == []
  end

  test "transforms params into database compatible one item note list" do
    params = %{"uuid-1" => "answer_1",
               "uuid-2" => "answer_2",
               "_csrf_token" => "token",
               "id" => "id",
               "note" => "extra_note"}

    notes = Notes.note_in(params)

    assert notes == [%{note: "extra_note"}]
  end
end
