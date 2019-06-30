defmodule AdvisorWeb.AdminController do
  use AdvisorWeb, :controller
  plug AdvisorWeb.Authentication.Gatekeeper, only: :admin

  def create_person(conn, params) do
    case Advisor.People.create(params) do
      :ok ->
        send_resp(conn, 201, "")
      error ->
        conn
        |> put_status(400)
        |> json(validation_error(error))
    end
  end

  defp validation_error(errors) do
    Enum.into(errors, %{}, &field_and_reason/1)
  end

  defp field_and_reason({field, {reason, _}}), do: {field, reason}

  def remove_person(conn, %{"email" => email}) do
    case Advisor.People.delete(email: email) do
      {0, _} -> send_resp(conn, 404, "Not found")
      {1, _} -> send_resp(conn, 200, "Deleted")
    end
  end

  def update_person(%Plug.Conn{body_params: body_params} = conn, %{"email" => email}) do
    case Advisor.People.update(email, body_params) do
      :ok ->
        send_resp(conn, 200, "")
      :not_found ->
        send_resp(conn, 404, "Not found")
      error ->
        conn
        |> put_status(400)
        |> json(validation_error(error))
    end
  end

  def show_questionnaires(conn, _params) do
    conn
    |> json(simplify(Advisor.Questionnaire.all()))
  end

  def show_people(conn, _params) do
    conn
    |> json(simplify(Advisor.People.everybody()))
  end

  defp simplify(%Advisor.Questionnaire{} = q) do
    %{mentee: q.mentee.name, mentor: q.mentor.name, id: q.id, advisors: advisors(q)}
  end

  defp simplify(%Advisor.Person{} = p) do
    %{name: p.name, email: p.email, is_mentor: p.is_mentor}
  end

  defp simplify(data) do
    Enum.map(data, &simplify/1)
  end

  def advisors(questionnarie) do
    Enum.map(questionnarie.advice, fn a -> a.advisor.name end)
  end
end
