defmodule Advisor.Repo.Migrations.RemoveRequesterColumnFromAdviceRequest do
  use Ecto.Migration

  def up do
    alter table("advice_requests") do
      remove(:requester_id)
    end
  end

  def down do
    alter table("advice_requests") do
      add(:requester_id, :integer, null: true, default: nil)
    end
  end
end
