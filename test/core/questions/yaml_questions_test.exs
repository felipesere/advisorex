defmodule Advisor.Core.Questions.YamlQuestionsTests do
  use ExUnit.Case
  alias Advisor.Core.Questions

  test "Finds the different kinds of questions from the YAML" do
    questions = Questions.all()
    assert %{technical:  _, client: _, community: _} = questions
  end

  test "Finds questions by id" do
    assert %{id: 3} = Questions.find([3]) |> List.first
  end

  test "Can strip the phrases" do
    assert Questions.find([1]) |> Questions.phrases == ["How has this person contributed to the success of their client?"]
  end
end
