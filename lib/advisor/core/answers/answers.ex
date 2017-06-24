defmodule Advisor.Core.Answers do
  alias Advisor.Repo
  alias Advisor.Core.Answer

  def store(params) do
    Repo.insert_all(Answer, all_answers(params), returning: true)
  end

  def all_answers(%{"id" => advice_request_id} = params) do
    Enum.reduce(params, [], fn({question_id, answer}, acc) ->
      case Integer.parse(question_id) do
        {id, ""} -> acc ++ [
          %{question_id: id,
            answer: answer,
            advice_request_id: advice_request_id}
        ]
        _ -> acc
      end
    end)
  end
end
