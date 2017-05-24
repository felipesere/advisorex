defmodule Advisor.Core.Answer do
  use Ecto.Schema

  schema "answers" do
    field :advice_request_id, :binary_id
    field :question_id, :integer
    field :answer, :string
    field :inserted_at, :utc_datetime
  end
end
