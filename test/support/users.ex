defmodule Advisor.Test.Support.Users do
  alias Advisor.Core.{Person, People}
  alias Advisor.Repo

  @people [
    %Person{name: "Chris Jordan", email: "cj@example.com"},
    %Person{name: "Sarah Johnston", email: "sjohnston@example.com"},
    %Person{name: "Uku Taht", email: "uku@example.com"},
    %Person{name: "Nick Dyer", email: "nick@example.com"},
    %Person{name: "Priya Patil", email: "priya@example.com"},
    %Person{name: "Rabea Gleissner", email: "rabea@example.com"},
    %Person{name: "Jim Suchy", email: "jim@example.com", is_group_lead: true},
    %Person{name: "Felipe Sere", email: "felipe@example.com", is_group_lead: true}
  ]

  def with(names) when is_list(names) do
    Enum.map(names, &__MODULE__.with/1)
  end

  def with(name) do
    case People.find_by(name: name) do
      nil -> add(name)
      person -> person
    end
  end

  def add(name) do
    @people
    |> Enum.find(fn p -> p.name == name end)
    |> Repo.insert!()
  end
end
