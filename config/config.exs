use Mix.Config

config :kaffe,
  producer: [
    endpoints: [kafka: 9092, localhost: 9092],
    topics: ["random_topic"]
  ]
