defmodule Advisor.Core.Question do
  use Ecto.Schema

  schema "questions" do
    field :phrase, :string
    field :kind,   :integer
  end
end
