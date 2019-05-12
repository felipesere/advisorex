defmodule Submit do
  use Phoenix.ConnTest
  alias AdvisorWeb.Router.Helpers, as: Routes

  @endpoint AdvisorWeb.Endpoint

  def questionnaire(conn, asking: asking, mentor: mentor, questions: questions) do
    proposal = %{
      :mentor => mentor.id,
      :advisors => Enum.into(asking, %{}, &as_true/1),
      :questions => Enum.into(questions, %{}, &as_true/1)
    }

    conn
    |> post("/request", proposal: proposal)
    |> html_response(200)
  end

  def answers(conn, answers, for: %{id: id}) do
    provide_advice = Routes.provide_advice_path(@endpoint, :create, id)

    conn
    |> post(provide_advice, answers)
  end

  def answers!(conn, answers, params) do
    conn
    |> answers(answers, params)
    |> html_response(200)
  end

  defp as_true(%{id: id}), do: as_true(id)

  defp as_true(value) do
    {to_string(value), "true"}
  end
end
