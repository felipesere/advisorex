defmodule AdvisorWeb.Router do
  use AdvisorWeb, :router

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
    get "/questionnaire/:id/delete", QuestionnaireController, :delete

    get "/healthcheck", HealthcheckController, :index

  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/auth/", AdvisorWeb do
    pipe_through :api
    # I want custom request and callback urls!
    get "/:provider", AuthenticationController, :login
    get "/:provider/callback", AuthenticationController, :callback
  end
end
