defmodule AdvisorWeb.DownloadSummaryControllerTest do
  use AdvisorWeb.ConnCase
  alias Advisor.Test.Support.Sample

  test "downloads answers as CSV", %{conn: conn} do
    questionnaire = Sample.questionnaire()

    download_path = Routes.download_summary_url(@endpoint, :export, questionnaire.id)

    conn
    |> ThroughTheWeb.login_as("Felipe Sere")
    |> get(download_path)
    |> response_content_type(:csv)
  end
end
