defmodule Advisor.Repo.Migrations.DeleteSampleUsers do
  use Ecto.Migration
  alias Advisor.Repo
  import Ecto.Query

  def up do
    from(p in "people", where: like(p.email, "%example.com"))
    |> Repo.delete_all()
  end

  def down do
    Repo.insert_all(
      "people",
      [
        %{name: "Daniel Irvine", email: "daniel@example.com"},
        %{name: "Chris Jordan", email: "cj@example.com"},
        %{name: "Daisy Mølving", email: "dmolving@example.com"},
        %{name: "Fabien Townsend", email: "fabien@example.com"},
        %{name: "Sarah Johnston", email: "sjohnston@example.com"},
        %{name: "Steve Kim", email: "skim@example.com"},
        %{name: "Gabriella Medas", email: "gmedas@example.com"},
        %{name: "Dan Pelensky", email: "dpelensky@example.com"},
        %{name: "Andrea Mazzarella", email: "amazzarella@example.com"},
        %{name: "Mollie Stephenson", email: "mollie@example.com"},
        %{name: "Christoph Gockel", email: "christoph@example.com"},
        %{name: "Jarkyn Soltobaeva", email: "jarkyn@example.com"},
        %{name: "Makis Otman", email: "makis@example.com"},
        %{name: "Uku Taht", email: "uku@example.com"},
        %{name: "Nick Dyer", email: "nick@example.com"},
        %{name: "Priya Patil", email: "priya@example.com"},
        %{name: "Rabea Gleissner", email: "rabea@example.com"},
        %{name: "Jim Suchy", email: "jim@example.com", is_group_lead: true}
      ]
    )

    Repo.insert!(
      %{
        name: "Enrique Comba Riepenhausen",
        email: "ecomba@example.com",
        is_group_lead: true
      }
    )

    Repo.insert!(%{name: "Amelia Suchy", email: "amelia@example.com", is_group_lead: true})
    Repo.insert!(%{name: "Felipe Sere", email: "felipe@example.com", is_group_lead: true})

    Repo.insert!(
      %{
        name: "Georgina McFadyen",
        email: "georgina@example.com",
        is_group_lead: true
      }
    )
  end
end
