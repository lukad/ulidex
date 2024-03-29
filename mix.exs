defmodule Ulidex.MixProject do
  use Mix.Project

  def project do
    [
      app: :ulidex,
      version: "0.2.1",
      elixir: "~> 1.13",
      elixirc_paths: elixirc_paths(Mix.env()),
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      description: "Generate ULIDs",
      source_url: "https://github.com/lukad/ulidex",
      package: %{
        licenses: ["MIT"],
        links: %{
          "GitHub" => "https://github.com/lukad/ulidex"
        }
      }
    ]
  end

  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger, :crypto]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:credo, "~> 1.6", only: [:dev, :test], runtime: false},
      {:ex_doc, "~> 0.28", only: :dev, runtime: false}
    ]
  end
end
