use Mix.Config

# For development, we disable any cache and enable
# debugging and code reloading.
#
# The watchers configuration can be used to run external
# watchers to your application. For example, we use it
# with brunch.io to recompile .js and .css sources.

config :advisor, AdvisorWeb.Endpoint,
  http: [port: 4000],
  debug_errors: true,
  code_reloader: false,
  check_origin: false,
  watchers: []


config :advisor, AdvisorWeb.Endpoint,
  live_reload: []

config :logger, :console, format: "[$level] $message\n"

config :phoenix, :stacktrace_depth, 20

config :advisor, Advisor.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "postgres",
  password: "",
  database: "advisor_dev",
  hostname: "localhost",
  pool_size: 10,
  ssl: true

config :advisor, FeatureToggle, emails: false

config :advisor, Advisor.Notifications.Email.Mailer, adapter: Swoosh.Adapters.Local
