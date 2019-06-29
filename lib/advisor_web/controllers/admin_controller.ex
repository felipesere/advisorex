defmodule AdvisorWeb.AdminController do
  use AdvisorWeb, :controller

  def create_person(conn, params) do
    case Advisor.People.create(params) do
      :ok -> send_resp(conn, 201, "")
      error -> conn |> put_status(400) |> json(validation_error(error))
    end
  end

  defp validation_error(errors) do
    errors
    |> Enum.into(%{}, &field_and_reason/1)
  end

  defp field_and_reason({field, {reason, _}}), do: {field, reason}
end
