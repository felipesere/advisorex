defmodule AdvisorWeb.Router do
  use AdvisorWeb, :router

  if Mix.env == :dev do
    # If using Phoenix
    forward "/sent_emails", Bamboo.EmailPreviewPlug
  end

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  scope "/", AdvisorWeb do
    pipe_through :browser # Use the default browser stack

    get "/", LandingPage, :index
    get "/logout", AuthenticationController, :logout

    get "/request", QuestionnairePage, :index
    post "/request", AdviceRequestController, :create
    get "/progress/:id", ProgressPage, :index

    get "/provide/:id", ProvideAdviceController, :index
    post "/provide/:id", ProvideAdviceController, :create

    get "/present/:id", PresentPage, :index
    get "/present/:id/download.csv", DownloadSummaryController, :export
    get "/dashboard", DashboardPage, :index
    post "/dashboard/settings", DashboardPage, :settings

    get "/questionnaire/:id/delete", QuestionnaireController, :delete

    get "/healthcheck", HealthcheckController, :index
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/auth/", AdvisorWeb do
    pipe_through :api
    # I want custom request and callback urls!
    get "/login", AuthenticationController, :login
    get "/callback", AuthenticationController, :callback
  end
end
