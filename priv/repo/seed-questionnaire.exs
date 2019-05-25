# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seed-questionnaire.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Advisor.Repo.insert!(%Advisor.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.
alias Advisor.Core.{Advice, People, Question, Questionnaire}
alias Advisor.Repo

if Mix.env() == :dev do
  Repo.delete_all(Questionnaire)

  leslie = People.find_by(name: "Leslie Knope")
  april = People.find_by(name: "April Ludgate")
  andy = People.find_by(name: "Andy Dwyer")
  donna = People.find_by(name: "Donna Meagle")

  Repo.insert!(
    %Questionnaire{
      mentor: leslie,
      mentee: april,
      message: "I want to run the animal shelter",
      questions: [
        %Question{phrase: "How is this persons humor?"},
        %Question{phrase: "Have they stumbled yet?"}
      ],
      advice: [%Advice{advisor: andy}, %Advice{advisor: donna}],
    }
  )
end
