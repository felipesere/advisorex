defmodule Advisor.Web.DownloadSummaryController do
  use Advisor.Web, :controller
  alias Advisor.Core.Summary

  plug  Advisor.Web.Authentication.Gatekeeper, only: :group_leads

  def export(conn, %{"id" => id}) do
    conn
    |> put_resp_content_type("text/csv")
    |> put_resp_header("content-disposition", "attachment; filename=\"advice.csv\"")
    |> send_resp(200, csv_content(id))
  end

  defp csv_content(id) do
    id
    |> Summary.for_download()
    |> encode
    |> to_string()
  end

  defp encode(content) do
    content
    |> CSV.Encoding.Encoder.encode()
    |> Enum.to_list
  end
end
