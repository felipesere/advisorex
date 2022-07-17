defmodule AdvisorWeb.QuestionsListPage do
  use AdvisorWeb, :controller

  alias Advisor.Question.PhrasesCatalog

  def index(conn, _params) do
    render(conn, "index.html", questions: PhrasesCatalog.all())
  end
end
