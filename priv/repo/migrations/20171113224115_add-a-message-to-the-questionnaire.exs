defmodule :"Elixir.Advisor.Repo.Migrations.Add-a-message-to-the-questionnaire" do
  use Ecto.Migration

  def up do
    alter table(:questionnaires) do
      add :message, :string, null: true
    end
  end

  def down do
    alter table(:questionnaires) do
      remove :message
    end
  end
end
