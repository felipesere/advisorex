defmodule ThroughTheCore do
  alias Advisor.Core.Answer

  def answer!(advisories, data) when is_list(advisories) do
    advisories
    |> Enum.each(fn advisory -> answer!(advisory, data) end)
  end

  def answer!(%{id: id}, with: data) do
    Answer.store(Map.put(data, "id", id))
  end
end
