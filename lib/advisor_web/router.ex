defmodule AdvisorWeb.Router do
  use AdvisorWeb, :router

  if Mix.env() == :dev do
    # If using Phoenix
    forward "/sent_emails", Bamboo.SentEmailViewerPlug
  end

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  scope "/", AdvisorWeb do
    pipe_through :browser

    # view the landing page
    get "/", LandingPage, :index
    get "/logout", AuthenticationController, :logout


    # view the fhe form to create a questionnaire
    get "/request", QuestionnairePage, :index

    # submit the questionnaire you want to create
    post "/request", AdviceRequestController, :create

    # view the status of a questionnaire, who are we waiting for and who is done
    get "/progress/:id", ProgressPage, :index

    # view the form for an advisor to fill out
    get "/provide/:id", ProvideAdviceController, :index

    # save the advice given by an advisor
    post "/provide/:id", ProvideAdviceController, :create

    # view the collected advice for a given questionnaire
    get "/present/:id", PresentPage, :index

    # download the collected advice as a CSV
    get "/present/:id/download.csv", DownloadSummaryController, :export

    # view your dashboard
    get "/dashboard", DashboardPage, :index

    # change your settings
    post "/dashboard/settings", DashboardPage, :settings

    # delete a given questionnaire
    get "/questionnaire/:id/delete", QuestionnaireController, :delete

    # keep loadbalancers happy
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
