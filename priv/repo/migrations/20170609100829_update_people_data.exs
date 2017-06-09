defmodule Advisor.Repo.Migrations.UpdatePeopleData do
  use Ecto.Migration
  import Ecto.Query
  alias Advisor.Core.Person

  def up do
    Advisor.Repo.insert_all(Person, [
      %{name: "Dan Pelensky ", profile_image: "https://8thlight.com/images/team/dan-pelensky-a099c13b.jpg", is_group_lead: false, email: "dpelensky@example.com"}
    ])

    people = from(p in Person, where: p.email == "ea@example.com")
    Advisor.Repo.delete_all(people)

    daniel = from(p in Person, where: p.name == "Daniel Irvine")
    Advisor.Repo.update_all(daniel, set: [is_group_lead: false])
  end

  def down do
    people = from(p in Person, where: p.email == "dpelensky@example.com")
    Advisor.Repo.delete_all(people)


    Advisor.Repo.insert_all(Person, [
                              %{name: "EA Liles", profile_image: "https://8thlight.com/images/team/ea-liles-be94765d.jpg", is_group_lead: false, email: "ea@example.com"},
    ])

    daniel = from(p in Person, where: p.name == "Daniel Irvine")
    Advisor.Repo.update_all(daniel, set: [is_group_lead: true])
  end
end
