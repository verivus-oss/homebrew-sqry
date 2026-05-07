class Sqry < Formula
  desc "Semantic code search tool"
  homepage "https://sqry.dev"
  version "13.0.7"
  license "MIT"

  head "https://github.com/verivus-oss/sqry.git", branch: "master"

  on_macos do
    on_arm do
      resource "sqry" do
        url "https://github.com/verivus-oss/sqry/releases/download/v13.0.7/sqry-macos-arm64"
        sha256 "a2dfa1e796a28931ceb712c35720d6e557bc20a052a1cd674f42d9fe238865de"
      end
      resource "sqry-mcp" do
        url "https://github.com/verivus-oss/sqry/releases/download/v13.0.7/sqry-mcp-macos-arm64"
        sha256 "bbb28da9c73572eb77e277236b66754d617fc4bfa12540130b93245300bf06d5"
      end
      resource "sqry-lsp" do
        url "https://github.com/verivus-oss/sqry/releases/download/v13.0.7/sqry-lsp-macos-arm64"
        sha256 "b70d2c25ddb9795c359eefaf8cbddeb679bc21a66c3ab60423c111454fca5cd3"
      end
      resource "sqryd" do
        url "https://github.com/verivus-oss/sqry/releases/download/v13.0.7/sqryd-macos-arm64"
        sha256 "5b0a46af725d5516eb375548cf1541451b57f1b6db55018127cf52b3cba6181a"
      end
    end

    on_intel do
      resource "sqry" do
        url "https://github.com/verivus-oss/sqry/releases/download/v13.0.7/sqry-macos-x86_64"
        sha256 "e765b2fbf85748594b2eacf875f126c9033c82cc2fdefd8a75ee9d81632ffcc0"
      end
      resource "sqry-mcp" do
        url "https://github.com/verivus-oss/sqry/releases/download/v13.0.7/sqry-mcp-macos-x86_64"
        sha256 "de0c9be002db5bcf77d754af91aef08f3ddbdbce1e9edf74a58f5c071d2c5ab6"
      end
      resource "sqry-lsp" do
        url "https://github.com/verivus-oss/sqry/releases/download/v13.0.7/sqry-lsp-macos-x86_64"
        sha256 "fe055e6a31093fa1ac97ccee8141e99dbb6bec3080759bb1cd6e5970143c3ca3"
      end
      resource "sqryd" do
        url "https://github.com/verivus-oss/sqry/releases/download/v13.0.7/sqryd-macos-x86_64"
        sha256 "7a3bde0055d8136151811e0676cfec738e5f8856569c453ce17b8705947ce91f"
      end
    end
  end

  on_linux do
    on_intel do
      resource "sqry" do
        url "https://github.com/verivus-oss/sqry/releases/download/v13.0.7/sqry-linux-x86_64"
        sha256 "0ae68ce44422424b81c32dc36f1be9723963a0ba92df7b2328dbd6c5040ca198"
      end
      resource "sqry-mcp" do
        url "https://github.com/verivus-oss/sqry/releases/download/v13.0.7/sqry-mcp-linux-x86_64"
        sha256 "b08f368dc10e6e06ba90f966ac2fb8f4b11f3b941309da47f6024fe93bed71e7"
      end
      resource "sqry-lsp" do
        url "https://github.com/verivus-oss/sqry/releases/download/v13.0.7/sqry-lsp-linux-x86_64"
        sha256 "c2a12b1559bf0837e118a62017d543312fc31520e26ac34831d3acace18160c2"
      end
      resource "sqryd" do
        url "https://github.com/verivus-oss/sqry/releases/download/v13.0.7/sqryd-linux-x86_64"
        sha256 "f9886e168fb5c4416b6dc7b779c2b2a3524e86aa378d0aca24dc3818d0f0a634"
      end
    end

    on_arm do
      resource "sqry" do
        url "https://github.com/verivus-oss/sqry/releases/download/v13.0.7/sqry-linux-arm64"
        sha256 "2007910258674a387eb6ce638977e506b8682d151711455e4b4b196b515a9456"
      end
      resource "sqry-mcp" do
        url "https://github.com/verivus-oss/sqry/releases/download/v13.0.7/sqry-mcp-linux-arm64"
        sha256 "197318f352a8ec9fbbd57c1d3844e21535f2c052f543771a07b69d6aeb08bf4f"
      end
      resource "sqry-lsp" do
        url "https://github.com/verivus-oss/sqry/releases/download/v13.0.7/sqry-lsp-linux-arm64"
        sha256 "93aeaca4d26dcb518b030518c736c1fc672d9df3e716738be620f67e59d66e23"
      end
      resource "sqryd" do
        url "https://github.com/verivus-oss/sqry/releases/download/v13.0.7/sqryd-linux-arm64"
        sha256 "8860f412d33f5e886ccab991098c161af116ad588c42b9d4a5ff538de568bfa0"
      end
    end
  end

  def install
    if build.head?
      # HEAD build: compile from source via cargo workspace.
      system "cargo", "install", "--locked", "--path", "sqry-cli", "--root", prefix
      system "cargo", "install", "--locked", "--path", "sqry-mcp", "--root", prefix
      system "cargo", "install", "--locked", "--path", "sqry-lsp", "--root", prefix
      system "cargo", "install", "--locked", "--path", "sqry-daemon", "--root", prefix
    else
      ["sqry", "sqry-mcp", "sqry-lsp", "sqryd"].each do |name|
        resource(name).stage do
          bin_file = Dir["*"].first
          chmod 0o755, bin_file
          bin.install bin_file => name
        end
      end
    end
  end

  def caveats
    <<~EOS
      Installed binaries: sqry, sqry-mcp, sqry-lsp, sqryd.

      Quick start:
        sqry index .            # index the current workspace
        sqry search "query"     # semantic search
        sqryd start             # start the workspace-aware daemon

      Documentation: https://sqry.dev
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/sqry --version")
  end
end
