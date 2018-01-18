defmodule Advisor.Core.Note do
  use Ecto.Schema

  schema "notes" do
    field :note, :string
    field :advice_request_id, :binary_id
  end
end
