defmodule Advisor.Core.AnswersTest do
  use ExUnit.Case
  alias Advisor.Core.Answers

  test "transforms params into database compatible answers" do
    params = %{"1" => "answer_1",
               "2" => "answer_2",
               "_csrf_token" => "token",
               "id" => "id"}

    [first, second] = Answers.all_answers_in(params)

    assert first ==  %{advice_request_id: "id", answer: "answer_2", question_id: 2}
    assert second == %{advice_request_id: "id", answer: "answer_1", question_id: 1}
  end
end
