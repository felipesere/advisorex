defmodule Advisor.Core.Questions.YamlQuestionsTests do
  use ExUnit.Case
  alias Advisor.Core.Questions.YamlQuestions
  alias Advisor.Core.Question

  test "Finds the different kinds of questions from the YAML" do
    questions = YamlQuestions.all()
    assert questions[:technical]  == [%Question{id: 3, phrase: "What should this person learn?", kind: 1},
                                      %Question{id: 4, phrase: "That other thing", kind: 1}]
    assert questions[:client]     == [%Question{id: 1, phrase:  "How well does this person manage the client relationships?", kind: 2}]
    assert questions[:community]  == [%Question{id: 2, phrase: "What has this person contributed to 8th Light recently?", kind: 3}]
  end

  test "Finds questions by id" do
    assert YamlQuestions.find([3]) == [%Question{id: 3, phrase: "What should this person learn?", kind: 1}]
  end

  test "Can strip the phrases" do
    assert [3] |> YamlQuestions.find() |> YamlQuestions.phrases == ["What should this person learn?"]
  end
end
