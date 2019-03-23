defmodule Advisor.Core.Person do
  use Ecto.Schema
  import Ecto.Changeset

  schema "people" do
    field(:name, :string)

    field(:profile_image, :string,
      default: "https://maxcdn.icons8.com/Share/icon/p1em/Users/user1600.png"
    )

    field(:is_group_lead, :boolean, default: false)
    field(:email, :string)
  end

  defimpl Bamboo.Formatter, for: Advisor.Core.Person do
    def format_email_address(person, _opts) do
      {person.name, person.email}
    end
  end

  def changeset(person, params \\ %{}) do
    cast(person, params, [:name, :profile_image, :is_group_lead])
  end
end
