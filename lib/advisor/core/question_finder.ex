defmodule Advisor.Core.QuestionFinder do
  alias Advisor.Core.Question
  alias Advisor.Repo
  import Ecto.Query

  def find_all(ids) do
    query = from q in Question,
      where: q.id in ^ids
    Repo.all(query)
  end
end
