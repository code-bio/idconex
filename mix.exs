defmodule Idconex.Mixfile do
  use Mix.Project

  def project do
    [app: :idconex,
     version: "0.1.1",
     description: description(),
     package: package(),
     elixir: "~> 1.3",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps()]
  end

  # Configuration for the OTP application
  #
  # Type "mix help compile.app" for more information
  def application do
    [applications: [:logger]]
  end

  # Dependencies can be Hex packages:
  #
  #   {:mydep, "~> 0.3.0"}
  #
  # Or git/path repositories:
  #
  #   {:mydep, git: "https://github.com/elixir-lang/mydep.git", tag: "0.1.0"}
  #
  # Type "mix help deps" for more examples and options
  defp deps do
    [{:ex_doc, "~> 0.14.3", only: [:dev]},
    {:credo, "~> 0.5.2", only: [:dev, :test]}]
  end

  defp description do
    """
    Identicon library with different hashing algorithms and variable grid- and image-sizes.
    """
  end

  defp package do
    [name: :idconex,
    maintainers: ["Christian Franzl"],
    links: %{"GitHub" => "https://github.com/code-bio/idconex"},
    licenses: ["Apache 2.0"]]
  end
end
