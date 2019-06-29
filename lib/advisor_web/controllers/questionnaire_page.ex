defmodule AdvisorWeb.QuestionnairePage do
  use AdvisorWeb, :controller
  alias AdvisorWeb.Authentication.User
  alias Advisor.People
  alias Advisor.Question.PhrasesCatalog

  plug AdvisorWeb.Authentication.Gatekeeper

  def index(conn, _params) do
    mentee = User.of(conn)
    everybody = People.everybody_but(mentee)
    mentors = Enum.filter(everybody, fn person -> person.is_mentor end)
    questions = PhrasesCatalog.all()

    render(conn, "request.html",
      mentee: mentee,
      mentors: mentors,
      everybody: everybody,
      questions: questions
    )
  end
end
