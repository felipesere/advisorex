defmodule Advisor.Repo.Migrations.RenameAdviceRequest do
  use Ecto.Migration

  def up do
    rename table("advice_requests"), to: table("advice")
  end

  def down do
    rename table("advice"), to: table("advice_requests")
  end
end
