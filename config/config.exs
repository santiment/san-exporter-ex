use Mix.Config

config :kaffe,
  producer: [
    endpoints: [localhost: 9092],
    topics: ["random_topic"]
  ]
