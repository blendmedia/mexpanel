defmodule Mexpanel.MixProject do
  use Mix.Project

  def project do
    [
      app: :mexpanel,
      version: "0.1.0",
      elixir: "~> 1.6",
      start_permanent: Mix.env() == :prod,
      package: package(),
      deps: deps()
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
      {:tesla, "~> 1.0.0-pre"},
      {:jason, "~> 1.0"},
      {:timex, "~> 3.3"}
    ]
  end

  defp package do
    [
      maintainers: ["Leif Gensert"],
      licenses: ["Apache 2.0"],
      links: %{"GitHub" => "https://github.com/blendmedia/mexpanel"},
    ]
  end
end
