defmodule Advisor.Core.Questions.YamlQuestionsTests do
  use ExUnit.Case
  alias Advisor.Core.Questions.YamlQuestions
  alias Advisor.Core.Question
  alias Advisor.Core.Questions.Server

  setup do
    Server.from_file("lib/advisor/core/questions/questions.yml")
    :ok
  end

  test "parses YAML file into server" do
    Server.stop()
    Server.from_content(~s"""
                          technical:
                          - "How could this person become a better pair?"
                          """
    )
    assert ["How could this person become a better pair?"] ==  Server.all().technical |> YamlQuestions.phrases
  end

  test "Finds the different kinds of questions from the YAML" do
    questions = Server.all()
    assert %{technical:  _, client: _, community: _} = questions
  end

  test "Finds questions by id" do
    assert %Question{id: 3} = Server.find([3]) |> List.first
  end

  test "Can strip the phrases" do
    assert Server.find([1]) |> Server.phrases == ["How has this person contributed to the success of their client?"]
  end
end
