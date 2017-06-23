defmodule Advisor.Web.Router do
  use Advisor.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", Advisor.Web do
    pipe_through :browser # Use the default browser stack

    get "/", LandingPage, :index
    post "/begin", LoginController, :index
    get "/request", QuestionnairePage, :index
    post "/request", AdviceRequestController, :create
    get "/progress/:id", ProgressPage, :index
    get "/provide/:id", ProvideAdviceController, :index
    post "/provide/:id", ProvideAdviceController, :create
    get "/present/:id", PresentPage, :index
    get "/present/:id/download.csv", DownloadSummaryController, :export
  end
end
