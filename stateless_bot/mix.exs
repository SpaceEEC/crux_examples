defmodule MyBot.MixProject do
  use Mix.Project

  def project do
    [
      app: :my_bot,
      version: "0.1.0",
      elixir: "~> 1.9",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {MyBot.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:crux_gateway, "~> 0.2"},
      {:crux_rest, "~> 0.2"}
    ]
  end
end
