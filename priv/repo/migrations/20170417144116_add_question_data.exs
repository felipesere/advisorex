defmodule Advisor.Repo.Migrations.AddQuestionData do
  use Ecto.Migration

  def up do
    Advisor.Repo.insert_all("questions", [
                              %{phrase: "How could this person become a better pair?", kind: 1},
                              %{phrase: "How could the this person improve their code quality?", kind: 1},
                              %{phrase: "How could this person improve their testing strategy?", kind: 1},
                              %{phrase: "How are this persons code reviews?", kind: 1},
                              %{phrase: "Is this person the technical lead for stories?", kind: 1},
                              %{phrase: "How well does this person know their tools?", kind: 1},
                              %{phrase: "How well does this person pick up new tools?", kind: 1},
                              %{phrase: "How has this person contributed to the success of their client?", kind: 2},
                              %{phrase: "How has this person navigated difficult situations with the client?", kind: 2},
                              %{phrase: "How well does this person communicate with the client?", kind: 2},
                              %{phrase: "How well does this person communicate with the team?", kind: 2},
                              %{phrase: "How does this person lead by example?", kind: 2},
                              %{phrase: "How has this person helped individuals at 8th Light improve?", kind: 3},
                              %{phrase: "How has this person helped 8th Light improve?", kind: 3},
                              %{phrase: "How well does this person explain techincal concepts to others?", kind: 3},
                              %{phrase: "What could this person do to become a better mentor?", kind: 3}
                              ])
  end

  def down do
    Advisor.Repo.delete_all("questions")
  end
end
