# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :concert_booking,
  ecto_repos: [ConcertBooking.Repo]

# Configures the endpoint
config :concert_booking, ConcertBooking.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "9iZP3lBomtDPS4pnVT1xslyJ8qwiSD59BPUSQaJ8rH2rsSjWAaciqtwoV524Fxiw",
  render_errors: [view: ConcertBooking.ErrorView, accepts: ~w(html json)],
  pubsub: [name: ConcertBooking.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Auth config
config :guardian, Guardian,
  issuer: "ConcertBooking.#{Mix.env}",
  ttl: {30, :days},
  verify_issuer: true,
  serializer: ConcertBooking.GuardianSerializer,
  secret_key: to_string(Mix.env) <> "SuPerseCret_aBraCadabrA"

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
