defmodule Advisor.Repo.Migrations.UseDefaultImageInDb do
  use Ecto.Migration
  import Ecto.Query
  alias Advisor.Repo

  def up do
    from(p in "people",
      where: [profile_image: ""],
      update: [
        set: [profile_image: "https://maxcdn.icons8.com/Share/icon/p1em/Users/user1600.png"]
      ]
    )
    |> Repo.update_all([])
  end

  def down do
    from(p in "people",
      where: [profile_image: 'https://maxcdn.icons8.com/Share/icon/p1em/Users/user1600.png'],
      update: [set: [profile_image: ""]]
    )
  end
end
