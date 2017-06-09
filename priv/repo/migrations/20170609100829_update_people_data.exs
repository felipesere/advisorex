defmodule Advisor.Repo.Migrations.UpdatePeopleData do
  use Ecto.Migration
  import Ecto.Query
  alias Advisor.Core.Person

  def change do
    Advisor.Repo.insert_all(Person, [
      %{name: "Dan Pelensky ", profile_image: "https://8thlight.com/images/team/dan-pelensky-a099c13b.jpg", is_group_lead: false, email: "dpelensky@example.com"}
    ])

    people = from(p in Person, where: p.name == "EA Liles")

    Advisor.Repo.delete_all(people)
  end
end
