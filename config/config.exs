# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
import Config

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
  source_email: "advisor@8thlight.com"

config :advisor, Advisor.Notifications.Email.Mailer,
  adapter: Bamboo.SendGridAdapter,
  api_key: System.get_env("SENDGRID_API_KEY")

config :advisor, AdvisorWeb.AdminController,
  api_key: System.get_env("ADVISOR_ADMIN_API_KEY")

config :advisor, Advisor.Question.PhrasesCatalog,
  path: './questions.yml'

config :advisor, Brand,
  icon: "https://8thlight.com/images/logos/logo-color-f66c53fd.png",
  logo: 'https://8thlight.com/images/branding/8th-Light-Logo-Color-No-Text-28048670.png',
  alt: '8th Light Logo'


config :advisor, FeatureToggle, emails: [only: ["Felipe Seré", "Rabea Gleissner"]]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
