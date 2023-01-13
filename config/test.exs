import Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :ahref_bug, AhrefBugWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "dfJAQ7aL/Q3uy0PjxemgwBF7vfTxcpdZ3587oXFCu985sQagEOCLP6loyi4vvu33",
  server: false

# In test we don't send emails.
config :ahref_bug, AhrefBug.Mailer,
  adapter: Swoosh.Adapters.Test

# Print only warnings and errors during test
config :logger, level: :warn

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime
