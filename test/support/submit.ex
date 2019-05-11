defmodule Submit do
  use Phoenix.ConnTest

  @endpoint AdvisorWeb.Endpoint

  def questionnaire(conn, asking: asking, group_lead: group_lead, questions: questions) do
    proposal = %{
      :group_lead => group_lead.id,
      :advisors => Enum.into(asking, %{}, &as_true/1),
      :questions => Enum.into(questions, %{}, &as_true/1)
    }

    conn
    |> post("/request", proposal: proposal)
    |> html_response(200)
  end

  defp as_true(%{id: id}), do: as_true(id)

  defp as_true(value) do
    {to_string(value), "true"}
  end
end
