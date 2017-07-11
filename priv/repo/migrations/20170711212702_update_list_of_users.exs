defmodule Advisor.Repo.Migrations.UpdateListOfUsers do
  use Ecto.Migration
  import Ecto.Query
  alias Advisor.Core.Person

  def up do
    users = ["dipak@example.com", "wcurry@example.com"]
    Advisor.Repo.delete_all(from(p in Person, where: p.email in ^users))
  end

  def down do
    Advisor.Repo.insert_all(Person, [
      %{name: "Dipak Pankhania", profile_image: "https://8thlight.com/images/team/dipak-pankhania-2b0055fe.jpg", is_group_lead: false, email: "dipak@example.com"},
      %{name: "Will Curry", profile_image: "https://8thlight.com/images/team/will-curry-46913dec.jpg", is_group_lead: false, email: "wcurry@example.com"}])
  end
end
