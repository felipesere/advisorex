defmodule Advisor.Repo.Migrations.TransferPreviousSchema do
  use Ecto.Migration

  def change do
    create table(:questions) do
      add(:phrase, :text)
      add(:kind, :integer)
    end

    create table(:people) do
      add(:name, :text, null: false)
      add(:profile_image, :text, null: false)
      add(:is_group_lead, :boolean, default: false, null: false)
      add(:email, :text, null: false)
    end

    create table(:questionnaires, primary_key: false) do
      add(:id, :uuid, primary_key: true, default: fragment("gen_random_uuid()"))
      add(:question_ids, {:array, :integer}, null: false)
      add(:requester_id, :integer, null: false)
    end

    create table(:advice_requests, primary_key: false) do
      add(:id, :uuid, primary_key: true, default: fragment("gen_random_uuid()"))
      add(:advice_request_id, :binary, null: false)
      add(:requester_id, :integer, null: false)
      add(:advisor_id, :integer, null: false)
    end

    create table(:answers) do
      add(:advice_request_id, references(:advice_requests, type: :uuid))
      add(:question_id, references(:questions), null: false)
      add(:answer, :text, null: false)
      timestamps(updated_at: false)
    end
  end
end
