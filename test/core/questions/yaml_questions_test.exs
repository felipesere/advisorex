defmodule Advisor.Core.Questions.YamlQuestionsTests do
  use ExUnit.Case
  alias Advisor.Core.Questions.YamlQuestions
  alias Advisor.Core.Question

  test "Finds the different kinds of questions from the YAML" do
    questions = YamlQuestions.all()
    assert %{technical:  _, client: _, community: _} = questions
  end

  test "Finds questions by id" do
    assert %Question{id: 3} = YamlQuestions.find([3]) |> List.first
  end

  test "Can strip the phrases" do
    assert YamlQuestions.find([1]) |> YamlQuestions.phrases == ["How has this person contributed to the success of their client?"]
  end
end
