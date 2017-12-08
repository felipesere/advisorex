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
  code_reloader: true,
  check_origin: false,
  watchers: [node: ["node_modules/brunch/bin/brunch", "watch", "--stdin",
                    cd: Path.expand("../assets", __DIR__)]]

config :advisor, AdvisorWeb.Endpoint,
  live_reload: [
    patterns: [
      ~r{priv/static/.*(js|css|png|jpeg|jpg|gif|svg)$},
      ~r{lib/advisor/web/views/.*(ex)$},
      ~r{lib/advisor/web/templates/.*(eex)$}
    ]
  ]

config :logger, :console, format: "[$level] $message\n"

config :phoenix, :stacktrace_depth, 20

config :advisor, Advisor.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "postgres",
  password: "",
  database: "advisor_dev",
  hostname: "localhost",
  pool_size: 10

config :ueberauth, Ueberauth,
  base_path: "/auth",
  providers: [
    google: {Local.Strategy, [request_path: "/auth/login",
                              callback_path: "/auth/callback"]}
    ]

config :advisor, FeatureToggle, emails: true

config :advisor, Advisor.Core.Notifications.Email.Mailer,
  adapter: Bamboo.LocalAdapter
