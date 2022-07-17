defmodule AdvisorWeb.Router do
  use AdvisorWeb, :router

  import AdvisorWeb.UserAuth

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :fetch_current_user
  end

  if Mix.env() in [:dev, :ci, :demo] do
    scope "/test/", AdvisorWeb do
      pipe_through :browser

      get "/questionnaire/delete-all", TestSupportController, :delete_all
    end

    forward "/sent_emails", Bamboo.SentEmailViewerPlug
  end

  scope "/", AdvisorWeb do
    pipe_through :browser

    # view the landing page
    get "/", LandingPage, :index
    get "/logout", AuthenticationController, :logout

    get "/questions", QuestionsListPage, :index

    # view the fhe form to create a questionnaire
    get "/request", QuestionnairePage, :index

    # submit the questionnaire you want to create
    # Lol this needs renaming
    post "/request", DraftQuestionnaireController, :create

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

  scope "/admin", AdvisorWeb do
    get "/people", AdminController, :show_people
    post "/people", AdminController, :create_person
    put "/people/:email", AdminController, :update_person
    delete "/people/:email", AdminController, :remove_person

    get "/questionnaires", AdminController, :show_questionnaires
    post "/questionnaires/:id/advisors/:email", AdminController, :add_advisor
    delete "/questionnaires/:id/advisors/:email", AdminController, :remove_advisor
  end

  ## Authentication routes

  scope "/", AdvisorWeb do
    pipe_through [:browser, :redirect_if_user_is_authenticated]

    get "/users/register", UserRegistrationController, :new
    post "/users/register", UserRegistrationController, :create
    get "/users/log_in", UserSessionController, :new
    post "/users/log_in", UserSessionController, :create
    get "/users/reset_password", UserResetPasswordController, :new
    post "/users/reset_password", UserResetPasswordController, :create
    get "/users/reset_password/:token", UserResetPasswordController, :edit
    put "/users/reset_password/:token", UserResetPasswordController, :update
  end

  scope "/", AdvisorWeb do
    pipe_through [:browser, :require_authenticated_user]

    get "/users/settings", UserSettingsController, :edit
    put "/users/settings", UserSettingsController, :update
    get "/users/settings/confirm_email/:token", UserSettingsController, :confirm_email
  end

  scope "/", AdvisorWeb do
    pipe_through [:browser]

    delete "/users/log_out", UserSessionController, :delete
    get "/users/confirm", UserConfirmationController, :new
    post "/users/confirm", UserConfirmationController, :create
    get "/users/confirm/:token", UserConfirmationController, :edit
    post "/users/confirm/:token", UserConfirmationController, :update
  end
end
