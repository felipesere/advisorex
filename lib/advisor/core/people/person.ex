defmodule Advisor.Core.Person do
  use Ecto.Schema
  import Ecto.Changeset

  schema "people" do
    field :name,          :string
    field :profile_image, :string,  default: ""
    field :is_group_lead, :boolean, default: false
    field :email,         :string
  end

  def changeset(person, params \\ %{}) do
    cast(person,  params, [:name, :profile_image, :is_group_lead])
  end
end
