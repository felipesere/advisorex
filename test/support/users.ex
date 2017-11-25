defmodule Advisor.Test.Support.Users do
  alias Advisor.Core.Person
  alias Advisor.Repo

  @people [
    %Person{name: "Daniel Irvine"              , email: "daniel@example.com"},
    %Person{name: "Chris Jordan"               , email: "cj@example.com"},
    %Person{name: "Daisy Mølving"              , email: "dmolving@example.com"},
    %Person{name: "Fabien Townsend"            , email: "fabien@example.com"},
    %Person{name: "Sarah Johnston"             , email: "sjohnston@example.com"},
    %Person{name: "Steve Kim"                  , email: "skim@example.com"},
    %Person{name: "Gabriella Medas"            , email: "gmedas@example.com"},
    %Person{name: "Dan Pelensky"               , email: "dpelensky@example.com"},
    %Person{name: "Andrea Mazzarella"          , email: "amazzarella@example.com"},
    %Person{name: "Mollie Stephenson"          , email: "mollie@example.com"},
    %Person{name: "Christoph Gockel"           , email: "christoph@example.com"},
    %Person{name: "Jarkyn Soltobaeva"          , email: "jarkyn@example.com"},
    %Person{name: "Makis Otman"                , email: "makis@example.com"},
    %Person{name: "Uku Taht"                   , email: "uku@example.com"},
    %Person{name: "Nick Dyer"                  , email: "nick@example.com"},
    %Person{name: "Priya Patil"                , email: "priya@example.com"},
    %Person{name: "Rabea Gleissner"            , email: "rabea@example.com"},
    %Person{name: "Jim Suchy"                  , email: "jim@example.com", is_group_lead: true},
    %Person{name: "Enrique Comba Riepenhausen" , email: "ecomba@example.com", is_group_lead: true},
    %Person{name: "Amelia Suchy"               , email: "amelia@example.com", is_group_lead: true},
    %Person{name: "Felipe Sere"                , email: "felipe@example.com", is_group_lead: true},
    %Person{name: "Georgina McFadyen"          , email: "georgina@example.com", is_group_lead: true}
  ]

  def with(names) when is_list(names) do
    Enum.map(names, fn(name) -> __MODULE__.with(name) end)
  end

  def with(name) do
    @people
    |> Enum.find(fn(p) -> p.name == name end)
    |> Repo.insert!()
  end
end
