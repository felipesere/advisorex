defmodule Advisor.Core.Person do
  use Ecto.Schema

  schema "people" do
    field :name,          :string
    field :profile_image, :string,  default: ""
    field :is_group_lead, :boolean, default: false
    field :email,         :string
  end
end
