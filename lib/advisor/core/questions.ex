defmodule Advisor.Core.Questions do
  alias Advisor.Repo
  alias Advisor.Core.Question
  import Ecto.Query

  def all() do
    Repo.all(Question)
    |> Enum.group_by(&( &1.kind))
    |> Enum.map(fn({k,v}) -> {convert_key(k), v} end)
    |> Enum.into(%{})
  end

  defp convert_key(key) do
    case key do
      1 -> :technical
      2 -> :client
      3 -> :community
    end
  end
end
