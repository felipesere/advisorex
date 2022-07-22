# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
import Config

# Configure esbuild (the version is required)
config :esbuild,
  version: "0.12.18",
  default: [
    args:
      ~w(css/app.css js/app.js --bundle --target=es2016 --outdir=../priv/static),
    cd: Path.expand("../assets", __DIR__),
    env: %{"NODE_PATH" => Path.expand("../deps", __DIR__)}
  ]

config :phoenix,
  json_library: Jason

# General application configuration
config :advisor,
  ecto_repos: [Advisor.Repo]

# Configures the endpoint
config :advisor, AdvisorWeb.Endpoint,
  url: [host: "localhost"],
  static_url: [path: "/assets"],
  secret_key_base: "SmmWRTx2vhEgHIcQ/7BRuQaIuvQ7fSeTrsFVuPsudiHKtD0AT068LXD61mN5Ow+d",
  pubsub_server: Advisor.PubSub

config :advisor, Advisor.Mailer, adapter: Swoosh.Adapters.Local

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :advisor, Advisor.Notifications.Emails,
  source_email: "advisor-app@felipesere.com"

config :advisor, Advisor.Notifications.Email.Mailer,
  adapter: Swoosh.Adapters.Sendgrid,
  api_key: System.get_env("SENDGRID_API_KEY")

config :advisor, AdvisorWeb.AdminController,
  api_key: System.get_env("ADVISOR_ADMIN_API_KEY")

config :advisor, Advisor.Question.PhrasesCatalog,
  path: './questions.yml'

config :advisor, Brand,
  icon: "/assets/favicon.ico",
  logo: "/assets/images/advisor-large.png",
  alt: 'Advisor Logo'


config :advisor, FeatureToggle, emails: [only: ["Felipe Seré", "Rabea Gleissner"]]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
