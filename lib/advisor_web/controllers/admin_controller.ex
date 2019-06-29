defmodule AdvisorWeb.AdminController do
  use AdvisorWeb, :controller
  plug AdvisorWeb.Authentication.Gatekeeper, only: :admin

  def create_person(conn, params) do
    create(conn, params)
  end

  def create(conn, params) do
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
    Advisor.People.delete(email: email)
    send_resp(conn, 200, "")
  end
end
