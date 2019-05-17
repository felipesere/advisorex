defmodule Advisor.Repo.Migrations.AddNewQuestionId do
  use Ecto.Migration
  import Ecto.Query
  alias Advisor.Repo

  def up do
    alter table(:questions) do
      add :new_id, :serial
    end

    flush()

    questions = from(q in "questions", select: [:id, :new_id]) |> Repo.all() |> IO.inspect
    # similar story for questionnaires

    questionnaires = from(q in "questionnaires", select: [:id, :question_ids]) |> Repo.all() |> IO.inspect



    for q <- questionnaires do

    end


    alter table(:questions) do
      remove(:id)
      modify(:new_id, :integer, primary_key: true)
    end

    flush()

    rename(table(:questions), :new_id, to: :id)
  end
end
