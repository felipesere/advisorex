defmodule Advisor.Core.Person do
  use Ecto.Schema

  schema "people" do
    field :name,          :string
    field :profile_image, :string
    field :is_group_lead, :boolean
    field :email,         :string
  end
end
