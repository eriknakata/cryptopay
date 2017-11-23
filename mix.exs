defmodule Cryptopay.Mixfile do
  use Mix.Project

  def project do
    [
      app: :cryptopay,
      version: "0.1.0",
      elixir: "~> 1.5",
      start_permanent: Mix.env == :prod,
      deps: deps(),

      # Docs
      name: "Cryptopay",
      source_url: "https://github.com/eriknakata/cryptopay",
      homepage_url: "http://YOUR_PROJECT_HOMEPAGE",
      docs: [main: "Cryptopay", # The main page in the docs
              #logo: "path/to/logo.png",
              extras: ["README.md"]]
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:mix_test_watch, "~> 0.3", only: :dev, runtime: false},
      {:httpoison, "~> 0.13"},
      {:poison, "~> 3.1"},
      {:ex_doc, "~> 0.16", only: :dev, runtime: false},
      {:decimal, "~> 1.0"}
    ]
  end
end
