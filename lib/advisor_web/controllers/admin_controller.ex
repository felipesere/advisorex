defmodule AdvisorWeb.AdminController do
  use AdvisorWeb, :controller

  @access_token :advisor
                |> Application.get_env(AdvisorWeb.AdminController, [])
                |> Keyword.fetch!(:api_key)

  def create_person(conn, params) do
    if authenticated?(conn) do
      create(conn, params)
    else
      unauthorized(conn)
    end
  end

  def unauthorized(conn) do
    send_resp(conn, 401, "Unauthorized")
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
    if authenticated?(conn) do
      Advisor.People.delete(email: email)
      send_resp(conn, 200, "")
    else
      unauthorized(conn)
    end
  end

  def authenticated?(conn) do
    token =
      conn
      |> get_req_header("authorization")
      |> parse()

    token == @access_token
  end

  def parse(["Bearer " <> token]), do: token
  def parse(_), do: :unauthorized
end
