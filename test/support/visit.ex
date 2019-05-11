defmodule Visit do
  use Phoenix.ConnTest
  alias AdvisorWeb.Router.Helpers, as: Routes

  # The default endpoint for testing
  @endpoint AdvisorWeb.Endpoint

  def the(conn, :landing_page) do
    conn
    |> get("/")
    |> html_response(200)
  end
end