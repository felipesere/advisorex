defmodule Advisor.Repo.Migrations.AddPeopleData do
  use Ecto.Migration

  def up do
    Advisor.Repo.insert_all("people", [
                              %{name: "Andrea Mazzarella", profile_image: "https://8thlight.com/images/team/andrea-mazzarella-84ba2525.jpg", is_group_lead: false, email: "amazzarella@example.com"},
                              %{name: "Chris Jordan", profile_image: "https://8thlight.com/images/team/chris-jordan-4997becf.jpg", is_group_lead: false, email: "cj@example.com"},
                              %{name: "Daniel Irvine", profile_image: "https://8thlight.com/images/team/daniel-irvine-d41af5ef.jpg", is_group_lead: true, email: "daniel@example.com"},
                              %{name: "Daisy Mølving", profile_image: "https://8thlight.com/images/team/daisy-m%C3%B8lving-31358bc2.jpg", is_group_lead: false, email: "dmolving@example.com"},
                              %{name: "Dipak Pankhania", profile_image: "https://8thlight.com/images/team/dipak-pankhania-2b0055fe.jpg", is_group_lead: false, email: "dipak@example.com"},
                              %{name: "EA Liles", profile_image: "https://8thlight.com/images/team/ea-liles-be94765d.jpg", is_group_lead: false, email: "ea@example.com"},
                              %{name: "Fabien Townsend", profile_image: "https://8thlight.com/images/team/fabien-townsend-3dffebba.jpg", is_group_lead: false, email: "fabien@example.com"},
                              %{name: "Jim Suchy", profile_image: "https://8thlight.com/images/team/jim-suchy-6d093cc9.jpg", is_group_lead: true, email: "jim@example.com"},
                              %{name: "Mollie Stephenson", profile_image: "https://8thlight.com/images/team/mollie-stephenson-6dc23a3a.jpg", is_group_lead: false, email: "mollie@example.com"},
                              %{name: "Amelia Suchy", profile_image: "https://8thlight.com/images/team/amelia-suchy-7b504935.jpg", is_group_lead: true, email: "amelia@example.com"},
                              %{name: "Felipe Sere", profile_image: "https://8thlight.com/images/team/felipe-sere-449ae9d6.jpg", is_group_lead: true, email: "felipe@example.com"},
                              %{name: "Georgina McFadyen", profile_image: "https://8thlight.com/images/team/georgina-mcfadyen-58eafc89.jpg", is_group_lead: true, email: "georgina@example.com"},
                              %{name: "Christoph Gockel", profile_image: "https://8thlight.com/images/team/christoph-gockel-5bb06d5b.jpg", is_group_lead: false, email: "christoph@example.com"},
                              %{name: "Jarkyn Soltobaeva", profile_image: "https://8thlight.com/images/team/jarkyn-soltobaeva-50bc5024.jpg", is_group_lead: false, email: "jarkyn@example.com"},
                              %{name: "Makis Otman", profile_image: "https://8thlight.com/images/team/makis-otman-2060e94d.jpg", is_group_lead: false, email: "makis@example.com"},
                              %{name: "Uku Taht", profile_image: "https://8thlight.com/images/team/uku-taht-537bae67.jpg", is_group_lead: false, email: "uku@example.com"},
                              %{name: "Nick Dyer", profile_image: "https://8thlight.com/images/team/nick-dyer-b33e6abd.jpg", is_group_lead: false, email: "nick@example.com"},
                              %{name: "Priya Patil", profile_image: "https://8thlight.com/images/team/priya-patil-f816f7eb.jpg", is_group_lead: false, email: "priya@example.com"},
                              %{name: "Rabea Gleissner", profile_image: "https://8thlight.com/images/team/rabea-gleissner-ce83c6d7.jpg", is_group_lead: false, email: "rabea@example.com"},
                              %{name: "Sarah Johnston", profile_image: "https://8thlight.com/images/team/sarah-johnston-8308f573.jpg", is_group_lead: false, email: "sjohnston@example.com"},
                              %{name: "Steve Kim", profile_image: "https://8thlight.com/images/team/steve-kim-9033837b.jpg", is_group_lead: false, email: "skim@example.com"},
                              %{name: "Will Curry", profile_image: "https://8thlight.com/images/team/will-curry-46913dec.jpg", is_group_lead: false, email: "wcurry@example.com"},
                              %{name: "Enrique Comba Riepenhausen", profile_image: "https://8thlight.com/images/team/enrique-comba-riepenhausen-d2708125.jpg", is_group_lead: true, email: "ecomba@example.com"},
                              %{name: "Gabriella Medas", profile_image: "https://8thlight.com/images/team/gabriella-medas-35614ef1.jpg", is_group_lead: false, email: "gmedas@example.com"},
                            ])
  end

  def down do
    Advisor.Repo.delete_all("people")
  end

end
