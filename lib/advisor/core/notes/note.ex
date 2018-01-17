defmodule Advisor.Core.Note do
  use Ecto.Schema

  @primary_key {:id, :binary_id, autogenerate: true}

  schema "notes" do
    field :note, :string
  end
end
