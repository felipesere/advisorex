defmodule Advisor.Repo.Migrations.EmailsNeedToUnique do
  use Ecto.Migration

  def up do
    create unique_index("people", :email)
  end

  def down do
    drop index("people", [:email])
  end
end
