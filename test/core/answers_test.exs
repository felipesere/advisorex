defmodule Advisor.Core.AnswersTest do
  use Advisor.DataCase
  alias Advisor.Core.Answers

  test "transforms params into database compatible answers" do
    params = %{"uuid-1" => "answer_1",
               "uuid-2" => "answer_2",
               "_csrf_token" => "token",
               "id" => "id",
               "note" => "extra_note"}

    [first, second] = Answers.all_answers_in(params)

    assert first == %{advice_request_id: "id", answer: "answer_1", question_id: "uuid-1"}
    assert second ==  %{advice_request_id: "id", answer: "answer_2", question_id: "uuid-2"}
  end
end
