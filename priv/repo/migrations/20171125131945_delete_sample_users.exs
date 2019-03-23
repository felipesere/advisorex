defmodule Advisor.Repo.Migrations.DeleteSampleUsers do
  use Ecto.Migration
  alias Advisor.Repo
  alias Advisor.Core.Person
  import Ecto.Query

  def up do
    from(p in "people", where: like(p.email, "%example.com")) |> Repo.delete_all()
  end

  def down do
    Repo.insert!(%Person{name: "Daniel Irvine", email: "daniel@example.com"})
    Repo.insert!(%Person{name: "Chris Jordan", email: "cj@example.com"})
    Repo.insert!(%Person{name: "Daisy Mølving", email: "dmolving@example.com"})
    Repo.insert!(%Person{name: "Fabien Townsend", email: "fabien@example.com"})
    Repo.insert!(%Person{name: "Sarah Johnston", email: "sjohnston@example.com"})
    Repo.insert!(%Person{name: "Steve Kim", email: "skim@example.com"})
    Repo.insert!(%Person{name: "Gabriella Medas", email: "gmedas@example.com"})
    Repo.insert!(%Person{name: "Dan Pelensky", email: "dpelensky@example.com"})
    Repo.insert!(%Person{name: "Andrea Mazzarella", email: "amazzarella@example.com"})
    Repo.insert!(%Person{name: "Mollie Stephenson", email: "mollie@example.com"})
    Repo.insert!(%Person{name: "Christoph Gockel", email: "christoph@example.com"})
    Repo.insert!(%Person{name: "Jarkyn Soltobaeva", email: "jarkyn@example.com"})
    Repo.insert!(%Person{name: "Makis Otman", email: "makis@example.com"})
    Repo.insert!(%Person{name: "Uku Taht", email: "uku@example.com"})
    Repo.insert!(%Person{name: "Nick Dyer", email: "nick@example.com"})
    Repo.insert!(%Person{name: "Priya Patil", email: "priya@example.com"})
    Repo.insert!(%Person{name: "Rabea Gleissner", email: "rabea@example.com"})
    Repo.insert!(%Person{name: "Jim Suchy", email: "jim@example.com", is_group_lead: true})

    Repo.insert!(%Person{
      name: "Enrique Comba Riepenhausen",
      email: "ecomba@example.com",
      is_group_lead: true
    })

    Repo.insert!(%Person{name: "Amelia Suchy", email: "amelia@example.com", is_group_lead: true})
    Repo.insert!(%Person{name: "Felipe Sere", email: "felipe@example.com", is_group_lead: true})

    Repo.insert!(%Person{
      name: "Georgina McFadyen",
      email: "georgina@example.com",
      is_group_lead: true
    })
  end
end
