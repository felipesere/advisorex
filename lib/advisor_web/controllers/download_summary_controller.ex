defmodule AdvisorWeb.DownloadSummaryController do
  use AdvisorWeb, :controller
  alias Advisor.Summary
  alias CSV.Encoding.Encoder

  plug AdvisorWeb.Authentication.Gatekeeper, only: :mentors

  def export(conn, %{"id" => id}) do
    conn
    |> put_resp_content_type("text/csv")
    |> put_resp_header("content-disposition", "attachment; filename=\"advice.csv\"")
    |> send_resp(200, csv_content(id))
  end

  defp csv_content(id) do
    id
    |> Summary.for_download()
    |> encode()
    |> to_string()
  end

  defp encode(content) do
    content
    |> Encoder.encode()
    |> Enum.to_list()
  end
end
