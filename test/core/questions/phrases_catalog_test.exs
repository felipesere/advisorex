defmodule Advisor.Question.PhrasesCatalogTests do
  use ExUnit.Case
  alias Advisor.Question.PhrasesCatalog
  alias Advisor.Question

  test "Finds the different kinds of questions from the YAML" do
    questions = PhrasesCatalog.all()
    assert %{technical: _, client: _, community: _} = questions
  end

  test "Finds questions by id" do
    assert %{id: 3} = PhrasesCatalog.find([3]) |> List.first()
  end

  test "Can strip the phrases" do
    assert PhrasesCatalog.find([1]) |> Question.phrases() == [
             "How has this person navigated difficult situations with the client?"
           ]
  end
end
