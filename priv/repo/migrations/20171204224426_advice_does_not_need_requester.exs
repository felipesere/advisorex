defmodule Advisor.Repo.Migrations.AdviceDoesNotNeedRequester do
  use Ecto.Migration

  def up do
   alter table("advice_requests") do
     modify :requester_id, :integer, [null: true, default: :nil]
   end
  end

  def down do
   alter table("advice_requests") do
     modify :requester_id, :integer, [null: false]
   end
  end
end
